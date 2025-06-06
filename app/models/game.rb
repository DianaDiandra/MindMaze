class Game < ApplicationRecord
  after_save :set_content, if: -> { saved_change_to_name? || saved_change_to_category? || saved_change_to_description? }

  has_many :performances, dependent: :destroy
  # has_many :users, through: :performances
  belongs_to :goal
  validates :mode, presence: true
  validates :name, presence: true
  validates :category, presence: true
  validates :embed_link, presence: true
  validates :description, presence: true

  DEFAULT_IMAGE = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.creativefabrica.com%2Fwp-content%2Fuploads%2F2023%2F07%2F04%2FCute-Brain-Exercising-With-A-Dumbell-73676685-1.png&f=1&nofb=1&ipt=ff6f538e85762a637be56b340357a551d156575e8d309a3daad726163fea7db8"

  def display_image
    image_url.presence || DEFAULT_IMAGE
  end

  def content
    if super.blank?
      set_content
    else
      super
    end
  end

  def set_content
    client = OpenAI::Client.new
    chatgpt_response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [{
          role: "user", content: "Give me an infomative yet brief #{description} for the
           game's #{name} and #{category}.Give me only the text of description alonside with the name and category , without any of your own answer like 'Here is a simple description'. Don t put any stars or all. At the end, add A Famous motivating quote"
        }]
      })
    new_content = chatgpt_response["choices"][0]["message"]["content"]
    update(content: new_content)
    return new_content
  end
end
