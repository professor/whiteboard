xml.chart do  
  xml.license "LTFQH6FM7R.O5BKH9F039YKA51.SUL"
  xml.chart_type "stacked column"
  xml.chart_data do  
    # first do label row
    xml.row do  
      xml.null("")
      for l in @labels_array do
        xml.string(l) 
      end
    end 
    # now do the data
    for r in @chart_data do
      label = r.first      
      xml.row do
        xml.string(label)
        for n in r[1..r.size] do
          xml.number(n)
        end
      end
    end
  end 
  # Axis category is the student names
  xml.axis_category "", "shadow"=>'low', "size"=>'10', "color"=>'FFFFFF', "alpha"=>'75', "orientation"=>'diagonal_down'
  xml.chart_label "", "suffix"=>' hrs', "decimals"=>"1", "position"=>'cursor', "size"=>'12', "color"=>'111122', "background_color"=>'aaff00', "alpha"=>'75'
  xml.legend "", "shadow"=>'low', "transition"=>'slide_left', "delay"=>'0.5', "duration"=>'1', "x"=>'125', "y"=>'25', "width"=>'250', "height"=>'10', "margin"=>'5', "fill_color"=>'ffffff', "fill_alpha"=>'60', "line_color"=>'000000', "line_alpha"=>'0', "line_thickness"=>'0', "layout"=>'horizontal', "size"=>'14', "color"=>'444466', "alpha"=>'95'
  # Axis value is the logged time xis
  xml.axis_value "", "shadow"=>'low', "size"=>'14', "color"=>'FFFFFF', "alpha"=>'75', "steps"=>'4', "prefix"=>'', "suffix"=>'', "decimals"=>'0', "separator"=>'', "show_min"=>'false', "orientation"=>'horizontal'
  xml.draw do
    xml.text "Week: " + @week_number.to_s, "shadow"=>'low', "color"=>'000022', "alpha"=>'40', "size"=>'41', "x"=>'200', "y"=>'20', "width"=>'390', "height"=>'295', "h_align"=>'right', "v_align"=>'top'
    xml.text "" + @date_range_start.to_s + " - " + @date_range_end.to_s,  "shadow"=>'low', "color"=>'000022', "alpha"=>'40', "size"=>'21', "x"=>'200', "y"=>'65', "width"=>'390', "height"=>'295', "h_align"=>'right', "v_align"=>'top' 
  end
end

