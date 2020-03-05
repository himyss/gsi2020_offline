void drawResults(TString fileName, TString treeName, Int_t nEvents) {
  
  TFile *inFile = new TFile(fileName.Data(),"READ");
  if(inFile->IsZombie()) {
    cerr << "No input file: " << fileName.Data() << endl;
    return;
  }

  TTree *t = (TTree*)inFile->Get(treeName.Data());
  if(t->IsZombie()) {
    cerr << "No tree with name: " << treeName.Data() << " in the file: " << fileName.Data() << endl;
    return;
  }

  TCanvas *c_rS = new TCanvas("c_rS","pedestal sigma distribution",1000,1000);
  c_rS->Divide(1,3);

  c_rS->cd(1);
  TGraph *g_sigma1 = new TGraph("./result/s_graph_1.txt"); 
  g_sigma1->Draw("AL");
  c_rS->Update();

  c_rS->cd(2);
  TGraph *g_sigma2 = new TGraph("./result/s_graph_2.txt"); 
  g_sigma2->Draw("AL");
  c_rS->Update();

  c_rS->cd(3);
  TGraph *g_sigma3 = new TGraph("./result/s_graph_3.txt"); 
  g_sigma3->Draw("AL");
  c_rS->Update();

  c_rS->SaveAs("result/sigma.root");
  c_rS->Print("result/sigma.png");

  TCanvas *c_rM = new TCanvas("c_rM","pedestal mean distribution",1000,1000);
  c_rM->Divide(1,3);

  c_rM->cd(1);
  TGraph *g_mean1 = new TGraph("./result/m_graph_1.txt"); 
  g_mean1->Draw("AL");
  c_rM->Update();

  c_rM->cd(2);
  TGraph *g_mean2 = new TGraph("./result/m_graph_2.txt"); 
  g_mean2->Draw("AL");
  c_rM->Update();

  c_rM->cd(3);
  TGraph *g_mean3 = new TGraph("./result/m_graph_3.txt"); 
  g_mean3->Draw("AL");
  c_rM->Update();

  c_rM->SaveAs("result/mean.root");
  c_rM->Print("result/mean.png");

  TCanvas *c_rA = new TCanvas("c_rA","amp distribution",1000,1000);
  c_rA->Divide(1,3);

  c_rA->cd(1);
  t->Draw("SST1E:SST1I >> amp1(1024,0,1024,4096,0,4096)","","col", nEvents, 0);
  c_rA->Update();

  c_rA->cd(2);
  t->Draw("SST2E:SST2I >> amp2(1024,0,1024,4096,0,4096)","","col", nEvents, 0);
  c_rA->Update();

  c_rA->cd(3);
  t->Draw("SST3E:SST3I >> amp3(1024,0,1024,4096,0,4096)","","col", nEvents, 0);
  c_rA->Update();

  c_rA->SaveAs("result/signal.root");
  c_rA->Print("result/signal.png");

  return;
}