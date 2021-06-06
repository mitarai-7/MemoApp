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

  SQL_READ = <<-SQL
  SELECT
    id,
    title,
    text
  FROM memos
  WHERE id = $1;
  SQL

  SQL_READALL = <<-SQL
  SELECT
    id,
    title,
    text
  FROM memos;
  SQL

  SQL_DELETE = <<-SQL
  DELETE
  FROM memos
  WHERE id = $1;
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
    @conn.prepare('read', SQL_READ)
    @conn.prepare('readall', SQL_READALL)
    @conn.prepare('delete', SQL_DELETE)
  end

  def create
    @conn.exec_prepared('create', %w[title text])
  end

  def read(id = nil)
    res = []
    if id.nil?
      @conn.exec_prepared('readall') do |memos|
        memos.each do |memo|
          res << { id: memo.values[0], title: memo.values[1], text: memo.values[2] }
        end
      end
    else
      @conn.exec_prepared('read', [id]) do |memos|
        memos.each do |memo|
          res << { id: memo.values[0], title: memo.values[1], text: memo.values[2] }
        end
      end
    end
    res
  end

  def delete(id)
    @conn.exec_prepared('delete', [id])
  end
end

mr = MemoRepository.new
# mr.create
# mr.delete(1)
p mr.read
