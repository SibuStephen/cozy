require 'fileutils'

class Node
  attr_accessor :name, :path, :type, :parent#, :read, :update, :delete
  
  include FileUtils
  
  def initialize(name, dir=ROOT_DIR)
    @name ||= name
    @type = (dir.split '/').last
    @parent = dir
    @path = File.join(dir, @name)
  end
  
  def create
    if Dir.exists? self.parent
      touch self.path
    else
      mkdir self.parent
      touch self.path
    end
  end
  
  def read(path)
    if File.exists? path
      content = File.open(path, 'r')
    else
      nil
    end
  end
  
  def update(path, newcontent='')
    File.open(path, 'w') {|f| f.write(newcontent)}
  end
  
  def delete(path)
    if File.exists? path
      rm path
    else
      "Not Found"
    end
  end
  
  def self.get_types
    types = []
    Dir[File.join(ROOT_DIR, "*")].each do |type|
      types << type.split('/').last if test ?d, type
    end
    types
  end
  
  def self.get_nodes
    nodes = Hash.new
    temp = []
    Dir[File.join(ROOT_DIR, "*")].each do |file|
      temp << file.split('/').last if test ?f, file
    end
    nodes['root'] = temp
    temp = []
    Node.get_types.each do |type|
      if Dir.entries(File.join(ROOT_DIR,type)).join != "..."
        nodes[type] = Dir.entries(File.join(ROOT_DIR,type)).select {|i| (i != '.') && (i != '..')}
      end
    end
    nodes
  end
  
  def self.find(node)
    entries = []
    entries = Dir.entries(node.parent) if Dir.exists? node.parent
    if entries.member? node.name
      Node.new(node.name)
    else
      nil
    end
  end
  
  def self.delete_parent_if_empty!(parent_path)
    if Dir.entries(parent_path).join == "..."
      FileUtils::rmdir parent_path
    end
  end
end