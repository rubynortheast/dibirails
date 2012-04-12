class AnswersController < ApplicationController
  respond_to :html
  
  def create
    @question = Question.find(params[:question_id])
    @question.answers.create(params[:answer])
    respond_with(@question)
  end 
  
end
