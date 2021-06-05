# frozen_string_literal: true

require 'pg'

class MemoRepository
  SQL_CREATE = <<-SQL
  INSERT INTO memos (
    title,
    text
  )
  VALUES (
    $1,
    $2
  );
  SQL

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
    @conn.prepare('create', SQL_CREATE)
  end

  def create
    res = @conn.exec_prepared('create', %w[title text])
    p res
  end
end

mr = MemoRepository.new
mr.create
