module PerformancesHelper
  def progress_color_class(accuracy)
    case accuracy
    when 90..100 then "bg-success"
    when 70..89  then "bg-info"
    when 50..69  then "bg-warning"
    else              "bg-danger"
    end
  end
end
