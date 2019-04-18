window.Utility ||= {}

class Utility.Settings
  @settings = {}

  constructor: ->
    $(document).on 'click', '.font-size', @handleFontSize
    $(document).on "click", '.word-tooltip', @handleTooltip
    $(document).on 'click', '#reset-setting', @resetSetting
    $(document).on 'click', '#toggle-nightmode', @toggleNightMode
    $(document).on 'click', '#toggle-readingmode', @toggleReadingMode

    $(document).on 'click', '.dropdown-menu.keep-open .dropdown-item', (e)->
      target = $(e.target)
      window.tt=target
      unless target.hasClass('dropdown-item')
        target = target.parent('.dropdown-item')

      target.toggleClass('active')
      e.stopPropagation()
      e.preventDefault()

    setting = try
      JSON.parse(localStorage.getItem("settings") || "{}")
    catch
      {}

    @settings = Object.assign(setting, @defaultSetting())

  toggleReadingMode: (e)->
    e.preventDefault()
    $("body").toggleClass('reading-mode')

  toggleNightMode: (e)->
    e.preventDefault()
    $("body").toggleClass('night')

  handleTooltip: (e) =>
    e.preventDefault()
    target = $(e.target)
    target.parent('.dropdown-menu')
    target.toggleClass('active')
    @settings.tooltip = target.data('tooltip') || target.parent().data('tooltip')

  handleFontSize: (e) =>
    e.preventDefault()
    that = $(e.target)
    target = that.closest('li').data('target')
    targetDom = $(target)

    size = parseInt targetDom.css('font-size'), 10
    size = if that.hasClass('increase') then size + 1 else size - 1

    @changeFontSize(targetDom, size)

  getTooltipType: =>
    if @settings.tooltip == 'transliteration'
      'tr'
    else
      't'

  changeFontSize: (target, size) =>
    target.css('font-size', size )
    window.matchMedia("(max-width: 610px)")

  resetSetting: (e) =>
    e.preventDefault()
    $('body').removeClass('night')
    @settings = @defaultSetting()
    @updatePage()

  updatePage: =>
    $(".translation").css('font-size', '20px')
    $(".word").css('font-size', '50px')

  defaultSetting: =>
    {
      font: 'qcf_v1',
      tooltip: 'translation',
      recitation:  '',
      nightMode: false,
      readingMode: false,
      translations: [],
      arabicFontSize: {
        mobile: 30,
        desktop: 50
      },
      translationFontSize: {
        mobile: 17,
        desktop: 20
      }
    }
