class Jogo
{
  public float escala = 1f;
  public Coord translacao = new Coord();
  
  Matriz matriz()
  {
    return 
      matrizIdentidade()
      .mult(matrizTranslacao(new Coord(width / 2f, height / 2f)))
      .mult(matrizTranslacao(translacao))
      .mult(matrizEscala(new Coord(escala, escala)))
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
    translate(width / 2, height / 2);
    translate(translacao.x, translacao.y);
    scale(escala);
  }
}
