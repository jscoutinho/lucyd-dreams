shader_type canvas_item;

uniform vec2 focus_position = vec2(0.5, 0.65);
uniform float focus_radius = 0.18;
uniform float edge_softness = 0.08;
uniform float darkness = 0.85;

void fragment() {
    vec2 pos = UV;

    float distance_from_focus = distance(pos, focus_position);

    float mask = smoothstep(
        focus_radius,
        focus_radius + edge_softness,
        distance_from_focus
    );

    COLOR = vec4(
        0.0,
        0.0,
        0.0,
        mask * darkness
    );
}