require_relative 'Produto'
require 'nokogiri'
require 'mechanize'
require 'open-uri'
require 'openssl'
require 'json'


OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
I_KNOW_THAT_OPENSSL_VERIFY_PEER_EQUALS_VERIFY_NONE_IS_WRONG = 1

agent_session = Mechanize.new { |agent|
  agent.user_agent = 'Mozilla/5.0 (Windows NT 6.1; Trident/7.0; rv:11.0) like Gecko'
}

@arquivo_saida = File.open("mercadolivre.csv", 'w')
@arquivo_saida.puts "nome_produto|preço"	

def get_produtos page, count
	
	page.xpath('.//ol[@id = "searchResults"]/li').each_with_index do |li|

		nomeproduto = li.xpath('.//h2[@class = "list-view-item-title"]/a/text()')

		preco_inteiro = li.xpath('(.//*[@class = "ch-price"])[1]/text()')
		preco_decimal = li.xpath('(.//*[@class = "ch-price"])[1]/sup/text()')
		preco = preco_inteiro.to_s.strip + "." + preco_decimal.to_s

		single_produto = Produto.new(nomeproduto,preco)

		#Gravando em arquivo_saida
		@arquivo_saida.write single_produto.to_csv_line
		@arquivo_saida.puts @string

		#Imprimindo na tela
		single_produto.to_s	

	end

end


begin
	url = "http://lista.mercadolivre.com.br/"
	print "\n\n\nPesquisar pelo nome do Produto: "
	nomeproduto = gets

	puts "\n\n\nPRODUTOS ENCONTRADOS NO MERCADO LIVRE\n\n\n"
	
	#agent_sesssion.get_produtos(url,produto,"")
	page = agent_session.get(url + nomeproduto)

	count = 0
	count = get_produtos page, count

	page_index = 1
	link_proxima = page.xpath('.//li[@class = "last-child"]/a/@href')


	loop do
		break if link_proxima.empty?

		page = agent_session.get(link_proxima.to_s)

		count = get_produtos page, count

		page_index += 1	
		link_proxima = page.xpath('.//li[@class = "last-child"]/a/@href')
    end
rescue Exception => e
end
	


