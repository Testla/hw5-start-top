$ !-> 
  bubbles = $ '#control-ring li'
  bar = $ '#info-bar'
  button = $ '#button'
  icon = $ '#icon'
  list = $ '#list'

  # 点击小气泡后显示小红圈，灭活其它气泡
  click-on-bubble = (certain-bubble) !->
    certain-bubble.state = 'clicked'
    little_red_circle = $ certain-bubble .children 'div'
    little_red_circle .css 'display','block' .html '...'
    for x in bubbles when x isnt certain-bubble and x.state is 'unclicked'
      $ x .remove-class 'enable' .add-class 'disable'
  
  # 显示数字，灭活已取得数字的气泡
  show-number = (certain-bubble, number) !->
    little_red_circle = $ certain-bubble .children 'div'
    little_red_circle .html number
    $ certain-bubble .remove-class 'enable' .add-class 'disable'

  # 激活其他未点击的小气泡
  change-state = !->
    for x in bubbles when x.state is 'unclicked'
      $ x .remove-class 'disable' .add-class 'enable'

  # 判断是否已获得所有数字，若是则激活大气泡
  all-number-got = !->
    for x in bubbles
      little_red_circle = $ x .children 'div'
      if x.state is 'unclicked' or little_red_circle .html is '...'
        return
    bar .remove-class 'disable' .add-class 'enable'

  # 计算数字的和并显示在大气泡上
  add-up = !->
    if bar .has-class 'enable' 
      sum = 0
      for x in bubbles
        sum += parseInt($ x .children 'div' .html!)
    if not bar .has-class 'disable'
      bar .children! .html sum
      bar .remove-class 'enable' .add-class 'disable'

  # 初始化计算器
  do init = !->
    for x in bubbles
      x.state = 'unclicked'
      $ x .remove-class 'disable' .add-class 'enable'
      little_red_circle = $ x .children 'div'
      little_red_circle .css 'display','none'
      bar .children! .html ''
    bar .remove-class 'enable' .add-class 'disable'
    icon .add-class 'unclicked'
    list .html ''

  # 小气泡点击事件
  bubbles.click !->
    if $ @ .has-class 'enable' and @.state is 'unclicked'
      click-on-bubble @
      $ .get '/' (number)!~>
        if @state is 'unclicked' or $ @ .has-class 'disable'
          return
        show-number @,number 
        change-state!
        all-number-got!

  # 大气泡点击事件
  bar.click !->
    add-up!

  # 鼠标离开则初始化计算器
  button.mouseleave !->
    init!

  # 生成随机序列
  generate-random-list = ->
    random-list = [0 to 4] .sort ->
      Math.random! - 0.5

  # 显示随机序列
  show-random-list = (random-list) !->
    random-list-character = ''
    for x in random-list
      switch x
        | 0    =>    random-list-character += 'A&nbsp'
        | 1    =>    random-list-character += 'B&nbsp'
        | 2    =>    random-list-character += 'C&nbsp'
        | 3    =>    random-list-character += 'D&nbsp'
        | 4    =>    random-list-character += 'E&nbsp'
    list .html random-list-character

  # 机器人程序
  robot = (random-list, index) !->
    if index < bubbles.length
      certain-bubble = bubbles[random-list[index]]
      click-on-bubble certain-bubble
      $ .get '/' (number) !->
        if certain-bubble.state is 'unclicked' or $ certain-bubble .has-class 'disable'
          return
        show-number certain-bubble,number
        change-state!
        all-number-got!
        robot random-list,index+1
    else
      add-up!

  # 点击@+触发机器人程序
  icon.click !->
    if not icon .has-class 'unclicked'
      return
    init!
    icon .remove-class 'unclicked'
    random-list = generate-random-list!
    show-random-list random-list
    robot random-list,0
