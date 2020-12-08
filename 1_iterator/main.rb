class Book
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

class BookShelf
  def initialize(maxsize)
    @books = Array(maxsize)
    @last = 0
  end

  def get_book_at(index)
    @books[index]
  end

  def append_book(book)
    @books[@last] = book
    @last += 1
  end

  def get_length
    @last
  end

  def iterator
    BookShelfIterator.new(self)
  end
end

class BookShelfIterator
  def initialize(book_shelf)
    @book_shelf = book_shelf
    @index = 0
  end

  def has_next
    @index < @book_shelf.get_length
  end

  def next
    book = @book_shelf.get_book_at(@index)
    @index += 1
    book
  end
end

book_shelf = BookShelf.new(4)
book_shelf.append_book(Book.new("Around the world in 80 Days"))
book_shelf.append_book(Book.new("Bible"))
book_shelf.append_book(Book.new("Cinderella"))
book_shelf.append_book(Book.new("Daddy-Lond-Legs"))
it = book_shelf.iterator
while it.has_next
  book = it.next
  pp book.name
end