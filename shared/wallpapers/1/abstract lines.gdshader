shader_type canvas_item;
render_mode unshaded;

uniform vec4 BackgroundColor : source_color = vec4(0.91765, 0.88627, 0.82745, 1.0);
uniform vec4 Layer1Color     : source_color = vec4(0.95686, 0.27451, 0.16078, 1.0);
uniform vec4 Layer2Color     : source_color = vec4(0.10980, 0.12157, 0.27843, 1.0);
uniform vec4 Layer3Color     : source_color = vec4(0.18824, 0.20000, 0.52157, 1.0);

const float degToRad = 0.01745329252;

float Rand(float i)
{
    return fract(sin(i * 23325.0) * 35543.0);
}

vec4 Rand4(float i)
{
    return fract(sin(i * vec4(23325.0, 53464.0, 76543.0, 12312.0)) *
                 vec4(35543.0, 63454.0, 23454.0, 87651.0));
}

mat2 Rot(float a)
{
    float s = sin(a);
    float c = cos(a);
    return mat2(vec2(c, -s), vec2(s, c));
}

float DrawLine(vec2 uv, vec2 a, vec2 b)
{
    vec2 ba = b - a;
    vec2 pa = uv - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - h * ba);
}

float DrawLineSegment(
    vec2 uv,
    float linesCount,
    float speed,
    float verticalAmplitude,
    float segmentSeed,
    float iTime
)
{
    float segmentMask = 0.0;

    float iterationStep = 1.0 / linesCount;
    float t = iTime * speed * 0.1;

    float horizontalAmplitude = 3.5;
    vec2 lineWidthRange = vec2(0.2, 1.5);
    vec2 lineSizeRange  = vec2(0.005, 0.035);

    float seedBase = Rand(segmentSeed);

    int count = int(linesCount);
    for (int j = 0; j <= count; j++)
    {
        float i = float(j) / linesCount;
        float unitSpeed = mix(0.5, 2.0, Rand(i));
        float seed = t * unitSpeed + i + seedBase;
        float it = fract(seed);
        vec4 iHash = Rand4(i);

        float normit = it * 2.0 - 1.0;

        float lineWidth = mix(lineWidthRange.x, lineWidthRange.y, pow(iHash.y, 2.0));

        vec2 ap = vec2(-horizontalAmplitude * normit, iHash.x * verticalAmplitude);
        vec2 bp = ap + vec2(lineWidth, 0.0);

        float lineSegmentDist = DrawLine(uv, ap, bp);

        float lineSize = mix(lineSizeRange.x, lineSizeRange.y, pow(iHash.z, 4.0));

        segmentMask += smoothstep(lineSize + 0.002, lineSize - 0.002, lineSegmentDist);
    }

    return clamp(segmentMask, 0.0, 1.0);
}

void fragment()
{
    vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 fragCoord = FRAGCOORD.xy;

    vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;

    uv.y = -uv.y;
    uv.x = -uv.x;

    uv *= Rot(degToRad * -35.0);

    vec3 bg = BackgroundColor.rgb;
    vec3 l1 = Layer1Color.rgb;
    vec3 l2 = Layer2Color.rgb;
    vec3 l3 = Layer3Color.rgb;

    vec3 col = mix(l1, bg, smoothstep(-0.055, -0.05, uv.y));
    col = mix(l2, col, smoothstep(-0.655, -0.65, uv.y));
    col = mix(l3, col, smoothstep(-1.305, -1.3, uv.y));

    col = mix(col, bg, DrawLineSegment(uv - vec2(0.0, -0.3), 9.0, 0.5, 0.35, 0.2, TIME));
    col = mix(col, l1, DrawLineSegment(uv - vec2(0.0,  0.0), 25.0, -0.4, 0.5, 0.1, TIME));

    col = mix(col, l1, DrawLineSegment(uv - vec2(0.0, -1.0), 25.0, -0.4, 0.45, 0.4, TIME));
    col = mix(col, l2, DrawLineSegment(uv - vec2(0.0, -0.65), 25.0, 0.3, 0.3, 0.3, TIME));

    col = mix(col, l2, DrawLineSegment(uv - vec2(0.0, -1.8), 25.0, 0.3, 0.55, 0.6, TIME));
    col = mix(col, l3, DrawLineSegment(uv - vec2(0.0, -1.3), 25.0, -0.2, 0.3, 0.5, TIME));

    COLOR = vec4(col, 1.0);
}