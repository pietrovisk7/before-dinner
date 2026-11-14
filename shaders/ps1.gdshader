// Shader de superfície estilo PS1. Compatível com o renderizador Compatibilidade.
// - Vértices "tremidos": a posição na tela é arredondada para uma grade grossa,
//   como o PS1 fazia por não ter precisão de subpixel.
// - Textura sem filtro (pixels duros) e repetível.
// A baixa resolução em si vem do SubViewport em scenes/main/main.tscn.
shader_type spatial;

// Cor multiplicada pela textura (sem textura = cor sólida).
uniform vec4 cor : source_color = vec4(1.0);
uniform sampler2D textura : source_color, filter_nearest, repeat_enable, hint_default_white;
// Repetição da textura na malha. Aumente em superfícies grandes (chão, paredes).
uniform vec2 escala_uv = vec2(1.0);
// Grade usada para "tremer" os vértices. Menor = mais tremido. 0 desliga o efeito.
uniform vec2 resolucao_tremor = vec2(320.0, 180.0);

void vertex() {
	UV *= escala_uv;

	// Ao escrever POSITION, o Godot deixa de projetar sozinho: precisamos escrever sempre.
	vec4 clip = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
	// Só arredonda o que está na frente da câmera (w > 0), senão a divisão explode.
	if (resolucao_tremor.x > 0.0 && clip.w > 0.0) {
		vec2 grade = resolucao_tremor * 0.5;
		vec2 ndc = clip.xy / clip.w;
		ndc = floor(ndc * grade + 0.5) / grade;
		clip.xy = ndc * clip.w;
	}
	POSITION = clip;
}

void fragment() {
	vec4 amostra = texture(textura, UV);
	ALBEDO = amostra.rgb * cor.rgb;
}
