# frozen_string_literal: true

require 'pg'

class MemoRepository
  def initialize
    @conn = PG::Connection.new(dbname: 'memo')
    # sql = <<-SQL
    #   CREATE TABLE memos (
    #     id SERIAL PRIMARY KEY,
    #     title VARCHAR(32),
    #     text TEXT
    #   );
    # SQL
    # @conn.exec(sql)
  end

  def create
    sql = <<-SQL
      INSERT INTO memos (
        title,
        text
      )
      VALUES (
        'hoge',
        'huga'
      );
    SQL
    @conn.exec(sql)
  end
end

mr = MemoRepository.new
mr.create
