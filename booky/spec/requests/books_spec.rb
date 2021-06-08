require 'rails_helper'

describe 'Books API', type: :request do
  let(:first_author) { FactoryBot.create(:author, first_name: 'George', last_name: 'Orwell', age: 15) }
  let(:second_author) { FactoryBot.create(:author, first_name: 'H.G', last_name: 'Wells', age: 15) }

  describe 'GET /books' do
    before do
      FactoryBot.create(:book, title: '1995', author: first_author)
      FactoryBot.create(:book, title: 'The Time Machine', author: second_author)
    end

    it 'returns all the books' do
      get '/api/v1/books'

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(2)
      expect(response_body).to eq(
        [
          {
            'id' => 1,
            'title' => '1995',
            'author_name' => 'George Orwell',
            'author_age' => 15
          },
          {
            'id' => 2,
            'title' => 'The Time Machine',
            'author_name' => 'H.G Wells',
            'author_age' => 15
          }
        ]
      )
    end

    it 'returns a subset of books based on limit' do
      get '/api/v1/books', params: { limit: 1 }

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [
          {
          'id' => 1,
          'title' => '1995',
          'author_name' => 'George Orwell',
          'author_age' => 15
          }
          ]
      )
    end

    it 'returns a subset of books based on limit and offset' do
      get '/api/v1/books', params: { limit: 1, offset: 1 }

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [{
          'id' => 2,
          'title' => 'The Time Machine',
          'author_name' => 'H.G Wells',
          'author_age' => 15
        }]
      )
    end
  end

  describe 'POST /books' do
    it 'create a new book' do
      expect do
        post '/api/v1/books', params: {
          book: { title: 'Javascript for dummy' },
          author: { first_name: 'Andy', last_name: 'Weir', age: 15 }
        }, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxfQ.w8ZOBMmU8STNymOHPN4EDqpchXitoU4-vSEFjHOTMFw" }
      end.to change { Book.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
      expect(Author.count).to eq(1)
      expect(response_body).to eq({
        'id' => 1,
        'title' => 'Javascript for dummy',
        'author_name' => 'Andy Weir',
        'author_age' => 15
      })
    end
  end

  describe 'DELETE /books/:id' do
    let!(:book) { FactoryBot.create(:book, title: '1995', author: first_author) }

    it 'deletes a book' do
      expect { delete "/api/v1/books/#{book.id}" }.to change { Book.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end
  end
end
