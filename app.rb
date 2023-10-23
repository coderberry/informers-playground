require "bundler/setup"

require "colorize"
require "informers"

class App
  class << self
    def predict_sentiment(values)
      model = Informers::SentimentAnalysis.new("./models/sentiment-analysis.onnx")
      model.predict(values)
    end

    def question_answering(question:, context:)
      model = Informers::QuestionAnswering.new("./models/question-answering.onnx")
      model.predict(question: question, context: context)
    end

    def named_entity_recognition(phrase)
      model = Informers::NER.new("./models/ner.onnx")
      model.predict(phrase)
    end

    def text_generation(phrase, max_length: 50)
      model = Informers::TextGeneration.new("./models/text-generation.onnx")
      model.predict(phrase, max_length: max_length)
    end

    def feature_extraction(phrase)
      model = Informers::FeatureExtraction.new("./models/feature-extraction.onnx")
      model.predict(phrase)
    end

    def fill_mask(phrase)
      model = Informers::FillMask.new("./models/fill-mask.onnx")
      model.predict(phrase)
    end
  end
end
