class FooService
  def run
    book = Book.first
    book.use_undefined_method
  end
end
