# frozen_string_literal: true

# Classe responsavel por gerar relatorio
class ReportsController < ApplicationController
  before_action :logged_in?
  def by_room
    @departments = Department.all
    @rooms = Room.where(department: @departments[0])
    @weeks = obtain_weeks_of_period
  end

  def generate_by_room
    require 'prawn/table'
    require 'prawn'

    Prawn::Document.generate('public/test.pdf', page_layout: :landscape) do |pdf|
      pdf.text 'Hello World!'
      # table_data = Array.new
      # table_data << ["Product name", "Product category"]
      # table_data << ['teste', 'teste2']
      # pdf.table(table_data, :width => 500, :cell_style => { :inline_format => true })
    end
  end

  def json_of_rooms_by_department
    department_code = params[:department_code]
    rooms = Room.where(department_id: department_code).select('id, name')
    render inline: obtain_room_list_with_name_id(rooms).to_json
  end

  def json_of_rooms_with_parts_of_name
    department_code = params[:department_code]
    part_name = params[:part_name]
    rooms = Room.where(department_id: department_code)
                .where('name LIKE ?', "%#{part_name}%").select('id, name')
    render inline: obtain_room_list_with_name_id(rooms).to_json
  end

  private

  def report_by_room_params
    params[:reports_by_room].permit(:departments, :all_rooms, :room_code,
                                    :initial_week, :last_week)
  end

  def obtain_room_list_with_name_id(rooms)
    rooms.map do |u|
      {
        id: u.id, name: u.name
      }
    end
  end

  def obtain_weeks_of_period
    weeks = []
    date = Period.find(1).initial_date.at_beginning_of_week
    last = Period.find(3).final_date.at_end_of_week
    while date <= last
      weeks.push date.strftime('%d/%m/%Y') + ' à ' + (date + 5.days)
                                                     .strftime('%d/%m/%Y')
      date += 7.days
      puts date.to_s
    end
    weeks
  end
end