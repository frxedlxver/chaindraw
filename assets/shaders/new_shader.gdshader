// Starfield Shader Modified to Use Screen Space Coordinates with Twinkling
// Original shader by Brian Smith (steampunkdemon.itch.io)
// Modified to use screen space and add twinkling by [Your Name]

shader_type canvas_item;

// Star parameters
uniform float small_stars = 50.0; // Number of small stars vertically
uniform float small_stars_far_size : hint_range(0.1, 1.0) = 0.3; // Reduced size
uniform float small_stars_near_size : hint_range(0.1, 1.0) = 0.6; // Reduced size

uniform float large_stars = 8.0; // Number of large stars vertically
uniform float large_stars_far_size : hint_range(0.1, 1.0) = 0.3; // Reduced size
uniform float large_stars_near_size : hint_range(0.1, 1.0) = 0.6; // Reduced size

// Star colors
uniform vec4 far_stars_color : source_color = vec4(0.5, 0.0, 1.0, 1.0);
uniform vec4 near_stars_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// Scroll speeds
uniform float base_scroll_speed : hint_range(0.0, 1.0, 0.01) = 0.05;
uniform float additional_scroll_speed : hint_range(0.01, 1.0, 0.01) = 0.05;

// Twinkling parameters
uniform float twinkle_speed : hint_range(0.1, 5.0) = 1.0; // Speed of twinkle
uniform float twinkle_intensity : hint_range(0.1, 1.0) = 0.5; // Intensity of twinkle

// Hash function for randomness
float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float greater_than(float x, float y) {
    return max(sign(x - y), 0.0);
}

void fragment() {
    float offset_x = 10000.0 + SCREEN_UV.x;

    // Screen resolution and aspect ratio
    vec2 screen_resolution = 1.0 / SCREEN_PIXEL_SIZE;
    float aspect_ratio = screen_resolution.x / screen_resolution.y;

    // Use SCREEN_UV for screen space coordinates (0.0 - 1.0)
    vec2 uv = SCREEN_UV;

    // Random numbers based on vertical position (y-coordinate)
    float small_star_rn = hash(floor(uv.y * small_stars));
    float large_star_rn = hash(floor(uv.y * large_stars));

    // Calculate star positions and apply horizontal scrolling
    vec2 small_star_uv = vec2(
        fract(uv.x + (base_scroll_speed + small_star_rn * additional_scroll_speed) * offset_x) * small_stars * aspect_ratio,
        fract(uv.y * small_stars)) * 2.0 - 1.0;

    vec2 large_star_uv = vec2(
        fract(uv.x + (base_scroll_speed + large_star_rn * additional_scroll_speed) * offset_x) * large_stars * aspect_ratio,
        fract(uv.y * large_stars)
    ) * 2.0 - 1.0;

    // Twinkling effect
    float twinkle = 0.5 + 0.5 * sin(TIME * twinkle_speed + small_star_rn * 6.283185); // Sine-based twinkle

    // Calculate star sizes and colors
    vec4 star_color = mix(far_stars_color, near_stars_color, small_star_rn) * (1.0 - twinkle_intensity + twinkle * twinkle_intensity);
    float star_size = mix(small_stars_far_size, small_stars_near_size, small_star_rn);

    // Render small stars as circles with soft edges
    float small_star_alpha = max((star_size - length(small_star_uv)) / star_size, 0.0) * star_color.a;
    COLOR.rgb = mix(COLOR.rgb, star_color.rgb, small_star_alpha);

    // Twinkle for large stars
    twinkle = 0.5 + 0.5 * sin(TIME * twinkle_speed + large_star_rn * 6.283185);
    star_color = mix(far_stars_color, near_stars_color, large_star_rn) * (1.0 - twinkle_intensity + twinkle * twinkle_intensity);
    star_size = mix(large_stars_far_size, large_stars_near_size, large_star_rn);

    // Render large stars with circles and crosses with smooth edges
    float cross_factor = max(greater_than(star_size / 10.0, abs(large_star_uv.x)), greater_than(star_size / 10.0, abs(large_star_uv.y)));
    float large_star_alpha = (
        max((star_size / 1.7 - length(large_star_uv)) / star_size, 0.0) +
        max((star_size - length(large_star_uv)) / star_size / 2.0, 0.0) * cross_factor
    ) * star_color.a;

    COLOR.rgb = mix(COLOR.rgb, star_color.rgb, large_star_alpha);
}
