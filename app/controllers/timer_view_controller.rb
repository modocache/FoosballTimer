class TimerViewController < UIViewController
  include BW::KVO

  GAME_TIME = 240

  ### UIViewController Overrides
  def viewDidLoad
    @seconds_passed = 0
    @update_label_timer = nil
    @is_playing = false

    self.view.backgroundColor = '#DB397A'.to_color
    self.setup_views
  end

  ### Internal Methods
  def setup_views
    component_height = (self.view.frame.size.height/4).floor

    label_frame = CGRectMake(0,
                             0,
                             self.view.frame.size.width,
                             component_height)
    @desc_label = UILabel.alloc.initWithFrame label_frame
    @desc_label.style_with_font_size(28.0)
    self.view.addSubview @desc_label

    timer_frame = CGRectMake(0,
                             component_height,
                             self.view.frame.size.width,
                             component_height)
    @remaining_time_label = UILabel.alloc.initWithFrame timer_frame
    @remaining_time_label.style_with_font_size(48.0)
    @remaining_time_label.text = '0s'
    self.view.addSubview @remaining_time_label

    button_padding = 80
    button_height = 50
    button_frame = CGRectMake(button_padding,
                              (component_height * 3 - button_height / 2).floor,
                              self.view.frame.size.width - button_padding * 2,
                              button_height)
    @button = UIButton::buttonWithType UIButtonTypeRoundedRect
    @button.frame = button_frame
    @button.when(UIControlEventTouchUpInside) do
      @is_playing ? self.stop_playing : self.start_playing
    end
    self.view.addSubview @button

    self.stop_playing
  end

  def stop_playing
    @desc_label.text = BW.localized_string(:play_some_foosball,
                                           'Play some foosball?')
    @button.setTitle(BW.localized_string(:start_game_button,
                                         'Start Game'),
                     forState:UIControlStateNormal)
    EM.cancel_timer(@update_label_timer) unless @update_label_timer.nil?
    @seconds_passed = 0
    @remaining_time_label.text = '0s'
  end

  def start_playing
    @desc_label.text = BW.localized_string(:enjoy_your_game,
                                           'Enjoy your game!')
    @button.setTitle(BW.localized_string(:stop_game_button,
                                         'Stop Game'),
                     forState:UIControlStateNormal)
    @remaining_time_label.text = "#{GAME_TIME}s"
    App.run_after(GAME_TIME) { self.time_is_up }
    @update_label_timer = EM.add_periodic_timer(1.0) do
      @seconds_passed += 1
      @remaining_time_label.text = "#{GAME_TIME - @seconds_passed}s"
    end
  end

  def time_is_up
    title = BW.localized_string(:game_over_alert_title,
                                'Game\'s over!')
    message = BW.localized_string(:game_over_alert_message,
                                  'Back to work, goons!')
    App.alert(title, message: message)
    self.stop_playing
  end

end
