#ifndef DGKIM_SAVEAS_H
#define DGKIM_SAVEAS_H

#include <vector>
#include <utility>
#include <TCanvas.h>
#include <TString.h>
#include <TSystem.h>


// 기본 SaveCanvas 함수: vector 입력용
inline void SaveCanvasWithParams(
    Filipad2* canvas,
    const std::vector<std::pair<TString, TString>>& params,
    const TString& prefix = "Jet",
    const TString& extension = ".pdf",
    const TString& directory = "Figs"
) {
    if (gSystem->AccessPathName(directory)) {
        gSystem->mkdir(directory, true); // 디렉토리 없으면 생성
    }

    TString filename = directory + "/" + prefix;
    for (const auto& p : params) {
        filename += Form("_%s=%s", p.first.Data(), p.second.Data());
    }
    filename += extension;
    canvas->SaveAs(filename);
}

// 편의용 initializer_list 버전: {{"key", "val"}} 형태 사용 가능
inline void SaveCanvasWithParams(
    Filipad2* canvas,
    std::initializer_list<std::pair<TString, TString>> params,
    const TString& prefix = "Jet",
    const TString& extension = ".pdf",
    const TString& directory = "Figs"
) {
    SaveCanvasWithParams(canvas, std::vector<std::pair<TString, TString>>(params), prefix, extension, directory);
}

#endif // DGKIM_SAVEAS_H