class GuiImagem extends GuiComponente
{
  public static final int MODO_ESTICAR = 0;
  public static final int MODO_CORTAR = 1;
  public static final int MODO_CABER = 2;
  private int modo;
  public Coord pos;
  public Coord tam;
  public Coord alinhamento;
  private PImage imagem;
  private float escalaCortar, escalaCaber;
  
  public GuiImagem(PImage imagem, Coord posicao, Coord tamanho, int modo, Coord alinhamento)
  {
    this.modo = modo;
    this.pos = posicao;
    this.tam = tamanho;
    this.imagem = imagem;
    this.alinhamento = alinhamento;
    
    float razaoX = tamanho.x / imagem.width;
    float razaoY = tamanho.y / imagem.height;
    escalaCortar = max(razaoX, razaoY);
    escalaCaber = min(razaoX, razaoY);
  }
  
  @Override
  void desenhar()
  {
    if (modo == MODO_ESTICAR)
    {
      image(imagem, pos.x, pos.y, tam.x, tam.y);
    }
    else if (modo == MODO_CORTAR)
    {
      clip(pos.x, pos.y, tam.x, tam.y);
      pushMatrix();
      translate(pos.x + alinhamento.x * (tam.x - imagem.width * escalaCortar), pos.y + alinhamento.y * (tam.y - imagem.height * escalaCortar));
      scale(escalaCortar);
      image(imagem, 0f, 0f);
      popMatrix();
      noClip();
    }
    else if (modo == MODO_CABER)
    {
      clip(pos.x, pos.y, tam.x, tam.y);
      pushMatrix();
      translate(pos.x + alinhamento.x * (tam.x - imagem.width * escalaCaber), pos.y + alinhamento.y * (tam.y - imagem.height * escalaCaber));
      scale(escalaCaber);
      image(imagem, 0f, 0f);
      popMatrix();
      noClip();
    }
  }
}
