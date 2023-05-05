import requests
import re
import json
from bs4 import BeautifulSoup

# weather icons
weather_icons = {
    'sunnyDay': '󰖙',
    'clearNight': '󰖔',
    'cloudyFoggyDay': '',
    'cloudyFoggyNight': '',
    'rainyDay': '',
    'rainyNight': '',
    'snowyIcyDay': '',
    'snowyIcyNight': '',
    'severe': '',
    'default': ''
}

# 从 weather.com 获取气象数据
url = "https://weather.com/zh-CN/weather/today/l/e3ce110931de2f1f12fedd529a6dab4d71e7bcc017ae5260d7a27c3ed5d840c6"
response = requests.get(url)
soup = BeautifulSoup(response.content, 'html.parser')

status_class_list = soup.find('div', {'id': 'regionHeader'}).get('class')
pattern = r'gradients--(.*?)-top'
result = re.search(pattern, ' '.join(status_class_list))
if result:
    status_code = result.group(1)
else:
    status_code = 'default'

# status icon
icon = (
    weather_icons[status_code]
    if status_code in weather_icons
    else weather_icons["default"]
)

# 获取当前天气状况
condition = soup.find('div', {'class': 'CurrentConditions--phraseValue--mZC_p'}).text

temp = soup.find('span', {'class': 'CurrentConditions--tempValue--MHmYY'}).text

# 获取体感温度
feels_like = soup.find('span', {'class': 'TodayDetailsCard--feelsLikeTempValue--2icPt'}).text

# 获取紫外线指数
uv_index = soup.find('span', {'data-testid': 'UVIndexValue'}).text

# 获取最高温度和最低温度
high_low_temp = soup.find('div', {'class': 'WeatherDetailsListItem--wxData--kK35q'}).find_all('span')
high_temp = high_low_temp[0].text
low_temp = high_low_temp[1].text

# 获取风速
wind_span = soup.find('span', {'data-testid': 'Wind'})
if (wind_span.svg):
    wind_span.svg.decompose()  # 移除 svg 标签
wind_speed = wind_span.text.strip()

# 获取湿度
humidity = soup.find('span', {'data-testid': 'PercentageValue'}).text

# 获取可见度
visibility = soup.find('span', {'data-testid': 'VisibilityValue'}).text

# 获取空气质量
air_quality = soup.find('div', {'class': 'AirQuality--col--3I-4C'}).text

# 获取降雨几率
precipitation_chance_li = soup.find("li", {'class': 'Column--column--3tAuz Column--active--27U5T'})
precipitation_chance_span = precipitation_chance_li.find("span", {"class": "Column--precip--3JCDO"})
precipitation_chance_span.span.decompose()
precipitation_chance = precipitation_chance_span.text

# 获取气压
pressure_span = soup.find('span', {'data-testid': 'PressureValue'})
if (pressure_span.svg):
    pressure_span.svg.decompose()  # 移除 svg 标签
pressure = pressure_span.text.strip()

# 获取日出日落时间
sunrise_sunset = soup.find_all('div', {'class': 'SunriseSunset--datesContainer--2cHyj'})[0].find_all('p')
sunrise_time = sunrise_sunset[0].text
sunset_time = sunrise_sunset[1].text

# 输出结果
print("当前天气状况:", condition)
print("温度:", temp)
print("体感温度:", feels_like)
print("紫外线指数:", uv_index)
print("最高温度:", high_temp)
print("最低温度:", low_temp)
print("风速:", wind_speed)
print("湿度:", humidity)
print("可见度:", visibility)
print("空气质量:", air_quality)
print("降雨几率:", precipitation_chance)
print("气压:", pressure)
print("日出时间:", sunrise_time)
print("日落时间:", sunset_time)

tooltip_text = str.format(
    "\t\t{}\t\t\n{}\n{}\n{}\n{}\n{}\n{}\n\n{}\n{}\n{}\n{}",
    f'<span size="xx-large">{temp}</span>',
    f"<big>{icon}</big>",
    f"<big>{condition}</big>",
    f"<small>体感温度 {feels_like}</small>",
    f"<small>紫外线指数 {uv_index}</small>",
    f"<small>空气质量 {air_quality}</small>",
    f"<small>󰖜  {sunrise_time}\t󰖛  {sunset_time}</small>",
    f"<big>  {low_temp}\t\t  {high_temp}</big>",
    f"<i>󰖝  {wind_speed}\t  {humidity}</i>",
    f"<i>  {visibility}\t󰡍  {pressure}</i>",
    f"<i>  (hourly) {precipitation_chance}</i>",
)

# tooltip_text += f'{temp_dist_icons}\n{temp_dist}\n\n{time_sunrise_sunset}'

# print waybar module data
out_data = {
    "text": f"{icon}   {temp}",
    "alt": condition,
    "tooltip": tooltip_text,
    "class": status_code,
}
print(json.dumps(out_data))

