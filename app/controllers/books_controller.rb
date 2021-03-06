class BooksController < ApplicationController
  def index
    # Load a list of books from somewhere
    if params[:author_id]
      # @books = Book.where(author_id: params[:author_id])

      # - or -

      author = Author.find_by(id: params[:author_id])
      if author
        @books = author.books
      else
        head :not_found
        return
      end
    else
      @books = Book.all
    end

    @featured_book = @books.sample
  end

  def new
    if params[:author_id]
      @author = Author.find_by(id: params[:author_id])
      if @author
        @book = @author.books.new
      else
        head :not_found
        return
      end
    else
      @book = Book.new
    end
  end

  def create
    # Params will contain data like this:
    # "book"=>{"title"=>"Dan Test Book", "author"=>"Test Author"}
    puts "Made it!"

    @book = Book.new(book_params)

    successful = @book.save
    if successful
      redirect_to books_path
    else
      render :new, status: :bad_request
    end
  end

  def show
    book_id = params[:id]

    @book = Book.find_by(id: book_id)

    unless @book
      head :not_found
    end
  end

  def edit
    book_id = params[:id]

    @book = Book.find_by(id: book_id)

    unless @book
      head :not_found
    end
  end

  def update
    @book = Book.find_by(id: params[:id])

    unless @book
      head :not_found
      return
    end

    # Update includes a save! Don't need to do it ourselves
    if @book.update(book_params)
      redirect_to book_path(@book)
    else
      render :edit, status: :bad_request
    end
  end

  def destroy
    book_id = params[:id]

    book = Book.find_by(id: book_id)

    unless book
      head :not_found
      return
    end

    book.destroy

    redirect_to books_path
  end

  private

  def book_params
    return params.require(:book).permit(:title, :author_id)
  end
end
