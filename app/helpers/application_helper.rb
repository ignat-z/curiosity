module ApplicationHelper
  def color_by_name(name)
    colors = %w[bg-green-400 bg-red-400 bg-blue-400 bg-gray-400 bg-yellow-400 bg-purple-400]
    colors[name[0].ord % colors.length]
  end
end
