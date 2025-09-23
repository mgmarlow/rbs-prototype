class Book < ApplicationRecord
  enum :status, %i[to_read reading finished]
end
