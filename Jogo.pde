class Jogo
{
  public float escala = 1f;
  public Coord translacao = new Coord();
  public float rotacao = 0f;
  Matriz matriz()
  {
    return 
      matrizIdentidade()
      .mult(matrizTranslacao(translacao))
      .mult(matrizEscala(new Coord(escala, escala)))
      .mult(matrizRotacao(rotacao))
      ;
  }
  
  Coord telaParaMundo(Coord coordTela)
  {
    return matriz().inversa().mult(coordTela);
  }
  
  Coord mundoParaTela(Coord coordMundo)
  {
    return matriz().mult(coordMundo);
  }
  
  void aplicarMatriz()
  {
    translate(translacao.x, translacao.y);
    scale(escala);
    rotate(rotacao);
  }
  
  void atualizar(float dt)
  {
  }
  
  void desenhar()
  {
  }
}
