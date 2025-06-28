shader_type spatial;
render_mode blend_mix, cull_front, unshaded, depth_test_disabled;

uniform vec4 color : source_color = vec4(0,0,0,0.5);
uniform float size : hint_range(1.0, 1.5, 0.01) = 1.1;

//bias: 0.17353355999581582 ( very probably the best of its kind )
uint lowbias32(uint x)
{
    x ^= x >> 16u;
    x *= 0x7feb352dU;
    x ^= x >> 15u;
    x *= 0x846ca68bU;
    x ^= x >> 16u;
    return x;
}


// bias: 0.020888578919738908 = minimal theoretic limit
uint triple32(uint x)
{
    x ^= x >> 17u;
    x *= 0xed5ad4bbU;
    x ^= x >> 11u;
    x *= 0xac4c1b51U;
    x ^= x >> 15u;
    x *= 0x31848babU;
    x ^= x >> 14u;
    return x;
}

void vertex() {
	VERTEX *= size;
}

void fragment() {
	ALBEDO = color.rgb;
	ALPHA = color.a;
}
