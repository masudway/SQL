-- Create enums for object types and classifications
CREATE TYPE celestial_type AS ENUM (
    'star', 'planet', 'moon', 'asteroid', 'comet', 'galaxy', 'nebula', 'black_hole'
);

CREATE TYPE planet_type AS ENUM (
    'terrestrial', 'gas_giant', 'ice_giant', 'dwarf'
);

-- Main celestial objects table
CREATE TABLE celestial_objects (
    object_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type celestial_type NOT NULL,
    discovery_date DATE,
    discovered_by VARCHAR(100),
    distance_from_earth_ly NUMERIC(20,2),
    mass_kg NUMERIC(30,2),
    diameter_km NUMERIC(20,2),
    mean_temperature_k NUMERIC(8,2),
    description TEXT,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Star-specific properties
CREATE TABLE stars (
    star_id INTEGER PRIMARY KEY REFERENCES celestial_objects(object_id),
    spectral_type VARCHAR(20),
    luminosity_solar NUMERIC(20,2),
    metallicity NUMERIC(6,3),
    estimated_age_years NUMERIC(12,2),
    surface_gravity_ms2 NUMERIC(10,2)
);

-- Planet-specific properties
CREATE TABLE planets (
    planet_id INTEGER PRIMARY KEY REFERENCES celestial_objects(object_id),
    planet_type planet_type,
    host_star_id INTEGER REFERENCES stars(star_id),
    orbital_period_days NUMERIC(12,2),
    orbital_radius_au NUMERIC(10,3),
    has_atmosphere BOOLEAN,
    has_magnetic_field BOOLEAN,
    number_of_moons INTEGER
);

-- Create indexes for common queries
CREATE INDEX idx_celestial_type ON celestial_objects(type);
CREATE INDEX idx_celestial_name ON celestial_objects(name);
CREATE INDEX idx_planet_host_star ON planets(host_star_id);

-- Sample data insertion
INSERT INTO celestial_objects (name, type, mass_kg, diameter_km, mean_temperature_k)
VALUES ('Sun', 'star', 1.989e30, 1392700, 5778);

INSERT INTO stars (star_id, spectral_type, luminosity_solar)
SELECT object_id, 'G2V', 1.0 FROM celestial_objects WHERE name = 'Sun';
