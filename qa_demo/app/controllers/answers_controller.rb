class AnswersController < ApplicationController
  respond_to :html
  
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(params[:answer])
    if @answer.save
      flash[:notice] =  "Your answer has been added successfully"
    else
      flash[:notice] =  "There is an issue with the answer have you provided"
    end 
    respond_with(@question)
  end
end
