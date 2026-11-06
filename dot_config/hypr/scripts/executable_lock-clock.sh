#!/bin/bash
#
# lock-clock.sh — the date and time for the lock screen's vertical label
#
# Usage:
#   lock-clock.sh    print the label's markup, one character per line
#
# hyprlock.conf runs this on a timer. Numbers are in kanji, like the bar's
# workspaces, and the hour is on a 12-hour clock, so 12:45 PM is 午後十二時四十五分.

# hyprlock's environment may not set a locale, and sed needs one to split kana.
export LC_ALL=C.UTF-8

numerals=("" 一 二 三 四 五 六 七 八 九)
days=(日 月 火 水 木 金 土)

# 1 to 59 in kanji.
kanji() {
    local tens=$(($1 / 10)) ones=$(($1 % 10))
    ((tens > 1)) && printf %s "${numerals[tens]}"
    ((tens > 0)) && printf 十
    printf %s "${numerals[ones]}"
}

read -r hour24 hour minute month day weekday < <(date '+%-H %-I %-M %-m %-d %w')

period=午前
((hour24 >= 12)) && period=午後
clock="$period$(kanji "$hour")時"
((minute > 0)) && clock+="$(kanji "$minute")分"

text="$(kanji "$month")月$(kanji "$day")日　${days[weekday]}曜日　$clock"
printf '<span font_weight="700" line_height="0.76">%s</span>' "$(sed 's/./&\n/g; s/\n$//' <<<"$text")"
