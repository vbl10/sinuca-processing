class GuiCaixaDeTexto extends GuiComponente {
  private String texto;
  private Coord pos;
  private Coord tam;
  private int corFundo; // Cor do fundo da caixa de texto

  public GuiCaixaDeTexto(String texto, Coord pos, Coord tam) {
    this.texto = texto;
    this.pos = pos;
    this.tam = tam;
    this.corFundo = color(200, 255); // Cor branca com 80% de opacidade (200 de 255)
  }
  
  public void atualizarTexto(String novoTexto) {
    this.texto = novoTexto;
  }
  
  public void setCorFundo(int cor) {
    this.corFundo = cor;
  }
  
  @Override
  void desenhar() {
    noStroke(); // Sem contorno
    
    // Desenha o retângulo de fundo com transparência
    fill(corFundo);
    rect(pos.x, pos.y, tam.x, tam.y); // Desenha o retângulo de fundo

    // Desenha o texto na caixa de texto
    fill(0); // Cor preta para o texto
    textAlign(LEFT, TOP); // Alinha o texto no canto superior esquerdo
    text(texto, pos.x + 5, pos.y + 5, tam.x - 10, tam.y - 10); // Desenha o texto com padding interno
  }
}
