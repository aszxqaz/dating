

fetch('https://geocode.maps.co/reverse?' + new URLSearchParams({
  lat: '55.9215627588',
  lon: '37.7603997888',
})).then(res => res.text()).then(console.log);