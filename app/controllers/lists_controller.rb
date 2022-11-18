# require 'open_uri'

class ListsController < ApplicationController
  before_action :set_list, only: [:show]

  def index
    @lists = List.all
  end

  def show
    @bookmarks = Bookmark.where('list_id = ?', @list.id)
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    uploaded_file = list_params[:picture]
    File.open(Rails.root.join('app', 'assets', 'images', uploaded_file.original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end
    # @list.picture.attach(io: file, filename: list_params[:name], content_type: uploaded_file.content_type)
    Cloudinary::Uploader.upload("/Users/rhny/code/romain-hny/rails-watch-list/app/assets/images/#{uploaded_file.original_filename}")
    if @list.save
      redirect_to list_path(@list)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name, :picture)
  end
end
