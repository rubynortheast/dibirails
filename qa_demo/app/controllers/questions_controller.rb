class QuestionsController < ApplicationController
  respond_to :html
  
  def index
    @questions = Question.all
    respond_with(@questions)
  end 
  
  def show
    @question = Question.find(params[:id])
    @answer = Answer.new
    respond_with(@questions)
  end
  
  def new
    @question = Question.new
    respond_with(@question)
  end 
  
  def create
    @question = Question.create(params[:question])
    respond_with(@question)
  end 
  
end
