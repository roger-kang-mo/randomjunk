require 'cards_against_humanity_cards'

class CardsController < ApplicationController

	def index

	end

	def single
		@cards = CardsAgainstHumanityCards.get_card

		respond_to do |format|
			format.html
		end
	end

	def get_cards
		white = params[:white]
		black = params[:black]

		@cards = CardsAgainstHumanityCards.get_card(white, black)

		respond_to do |format|
			format.json { render :json => { cards: @cards }}
		end
	end

end