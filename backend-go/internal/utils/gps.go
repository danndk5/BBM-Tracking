package utils

import (
	"math"
)

// Haversine formula untuk hitung jarak antara 2 koordinat GPS
func CalculateDistance(lat1, lon1, lat2, lon2 float64) float64 {
	const earthRadius = 6371000 // meter

	lat1Rad := lat1 * math.Pi / 180
	lat2Rad := lat2 * math.Pi / 180
	deltaLat := (lat2 - lat1) * math.Pi / 180
	deltaLon := (lon2 - lon1) * math.Pi / 180

	a := math.Sin(deltaLat/2)*math.Sin(deltaLat/2) +
		math.Cos(lat1Rad)*math.Cos(lat2Rad)*
			math.Sin(deltaLon/2)*math.Sin(deltaLon/2)

	c := 2 * math.Atan2(math.Sqrt(a), math.Sqrt(1-a))

	return earthRadius * c // dalam meter
}

// Validasi apakah driver berada dalam radius SPBU
func IsWithinRadius(driverLat, driverLon, spbuLat, spbuLon, radius float64) bool {
	distance := CalculateDistance(driverLat, driverLon, spbuLat, spbuLon)
	return distance <= radius
}
