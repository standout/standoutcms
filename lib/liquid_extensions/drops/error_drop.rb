# Not really a liquid drop, but it drips like one
# Usage:
#   class MyModelDrop < Liquid::Drop
#     ...
#     def errors
#       ErrorDrop.new(my_model.errors)
#     end
#   end
#   <input type="text"
#     {% if my_model.errors contains 'my_property' %} class="error"{% endif %}>
#   {% for error in my_model.errors.my_property %}
#   <small>{{error}}</small>
#   {% endfor %}
class ErrorDrop
  def self.new(errors)
    klass = Struct.new(*errors.keys) do
      def to_liquid
        self.to_h.stringify_keys
      end
    end
    @errors = klass.new(*errors.values)
  end
end
