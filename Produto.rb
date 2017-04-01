class Produto

	attr_reader :nomeproduto
	attr_reader :preco

	
	def initialize (nomeproduto, preco)
		@nomeproduto = nomeproduto
		@preco = preco
	end
	
	def to_s
			puts "Nome do produto: #{@nomeproduto}"
			puts "Preço: #{@preco}"
			puts "\n\n"
	end
	
	def to_csv_line    		
		column_separator = "|"
		return  "#{@nomeproduto} #{column_separator} #{@preco} #{column_separator}"
	end
end