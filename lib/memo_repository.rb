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
  FROM memos
  ORDER BY id;
  SQL

  SQL_UPDATE = <<-SQL
  UPDATE memos
  SET
    title = $2,
    text = $3
  WHERE id = $1;
  SQL

  SQL_DELETE = <<-SQL
  DELETE
  FROM memos
  WHERE id = $1;
  SQL

  SQL_INITTABLE = <<-SQL
  CREATE TABLE memos (
    id SERIAL PRIMARY KEY,
    title VARCHAR(32),
    text TEXT
  );
  SQL

  def initialize
    res = `psql -l | grep "memoapp"`
    p res
    `createdb memoapp` unless res.include?('memoapp ')

    res = `psql memoapp -c "select * from pg_tables where tablename = 'memos'" | grep "memos"`
    p res
    `psql memoapp -c "#{SQL_INITTABLE}"` unless res.include?('memos ')

    @conn = PG::Connection.new(dbname: 'memoapp')
    @conn.prepare('create', SQL_CREATE)
    @conn.prepare('read', SQL_READ)
    @conn.prepare('readall', SQL_READALL)
    @conn.prepare('update', SQL_UPDATE)
    @conn.prepare('delete', SQL_DELETE)
  end

  def create(title, text)
    @conn.exec_prepared('create', [title, text])
  end

  def read(id = nil)
    res = []
    if id.nil?
      @conn.exec_prepared('readall') do |memos|
        memos.each do |memo|
          res << { id: memo.values[0], memo_title: memo.values[1], memo_text: memo.values[2] }
        end
      end
    else
      @conn.exec_prepared('read', [id]) do |memos|
        memos.each do |memo|
          res << { id: memo.values[0], memo_title: memo.values[1], memo_text: memo.values[2] }
        end
      end
    end
    res
  end

  def update(id, title, text)
    @conn.exec_prepared('update', [id, title, text])
  end

  def delete(id)
    @conn.exec_prepared('delete', [id])
  end
end
