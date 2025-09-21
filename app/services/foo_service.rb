class FooService
  def run
    book_a = Book.find_by(title: "Foo Bar")
    book_b = Book
      .where(status: :completed)
      .where("updated_at < ?", Date.current)
      .first

    book_a || book_b
  end
end
