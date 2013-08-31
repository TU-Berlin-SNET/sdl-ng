module ModelAttributes
  def self.included(base)
    base.class_eval do
      def self.model_attributes
        @model_attributes ||= []
      end
    end
  end
end