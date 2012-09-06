class UILabel
  def style_with_font_size(font_size)
    self.backgroundColor = UIColor.clearColor
    self.font = UIFont.boldSystemFontOfSize(font_size)
    self.shadowOffset = CGSizeMake(0, 1)
    self.shadowColor = BW.rgba_color(0, 0, 0, 0.5)
    self.textColor = UIColor.whiteColor
    self.textAlignment = UITextAlignmentCenter
  end
end
