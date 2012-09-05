class TimerViewController < UIViewController
  ### UIViewController Overrides
  def viewDidLoad
    @seconds_passed = 0
    @update_label_timer = nil
    @game_timer = nil
    @is_playing = false

    self.view.backgroundColor = UIColor::grayColor
    self.setup_views
  end

  ### Internal Methods
  def setup_views
    label_height = 40
    timer_height = 150
    timer_padding = 20
    button_height = 50
    button_padding = 80

    label_frame = CGRectMake(
      0, 40,
      self.view.frame.size.width, label_height
    )
    @desc_label = UILabel.alloc.initWithFrame label_frame
    @desc_label.backgroundColor = UIColor::clearColor
    @desc_label.textAlignment = UITextAlignmentCenter
    self.view.addSubview @desc_label

    timer_frame = CGRectMake(
      0, @desc_label.frame.origin.y + @desc_label.frame.size.height + timer_padding,
      self.view.frame.size.width, timer_height
    )
    @game_timer_label = UILabel.alloc.initWithFrame timer_frame
    @game_timer_label.text = '0'
    @game_timer_label.backgroundColor = UIColor::clearColor
    @game_timer_label.textAlignment = UITextAlignmentCenter
    self.view.addSubview @game_timer_label

    button_frame = CGRectMake(
      button_padding, ((self.view.frame.size.height + label_height)/2).floor,
      self.view.frame.size.width - button_padding*2, button_height
    )
    @button = UIButton::buttonWithType UIButtonTypeRoundedRect
    @button.frame = button_frame
    @button.addTarget(
      self,
      action:'did_tap_button',
      forControlEvents:UIControlEventTouchUpInside
    )
    self.view.addSubview @button

    self.stop_playing
  end

  def did_tap_button
    if @is_playing then self.stop_playing else self.start_playing end
  end

  def stop_playing
    @desc_label.text = 'Play some foosball?'
    @button.setTitle('Start Game', forState:UIControlStateNormal)
    @update_label_timer.invalidate unless @update_label_timer.nil?
    @game_timer.invalidate unless @game_timer.nil?
    @seconds_passed = 0
  end

  def start_playing
    @desc_label.text = 'Enjoy your game!'
    @button.setTitle('Stop Game', forState:UIControlStateNormal)
    @update_label_timer = NSTimer::scheduledTimerWithTimeInterval(
      1,
      target:self,
      selector:'update_label',
      userInfo:nil,
      repeats:true
    )
    @game_timer = NSTimer::scheduledTimerWithTimeInterval(
      240,
      target:self,
      selector:'time_is_up',
      userInfo:nil,
      repeats:false
    )
  end

  def update_label
    @seconds_passed += 1
    @game_timer_label.text = (240 - @seconds_passed).to_s
  end

  def time_is_up
    av = UIAlertView.alloc.initWithTitle(
      "Game's over!",
      message: 'Back to work, goons!',
      delegate: nil,
      cancelButtonTitle: 'OK',
      otherButtonTitles: nil
    )
    av.show
    self.stop_playing
  end

end
