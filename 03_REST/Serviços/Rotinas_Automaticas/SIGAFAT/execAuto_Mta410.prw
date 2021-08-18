#include "protheus.ch
#Include 'FWMVCDEF.ch'
#Include 'RestFul.CH'

WSRESTFUL EXECAUTO410 DESCRIPTION "SERVIÇO ROTINA AUTOMATICA MATA410"
    WSMETHOD POST DESCRIPTION "Retorno dados EXECAUTO MATA410" WSSYNTAX "/EXECAUTO410"
END WSRESTFUL

WSMETHOD POST WSSERVICE EXECAUTO410
    Local nX      := 0
    Local aHeader := {}
    Local aLine   := {}
    Local aItems  := {}
    Local lValid  := .T.
    Local lError  := .F.
    Local cBody   := DecodeUTF8(::GetContent())
    Local oJson   := JsonObject():New()
    Local bError  := ErrorBlock({|oError| lError := !Empty(oError:Description)})

    Private lMsErroAuto := .F.
    Private lMsHelpAuto := .T.

    oJson:FromJson(cBody)
    ::SetContentType("application/json")

    AAdd(aHeader, {"C5_NUM",     PadR(oJson["header"]["number"],         TamSX3("C5_NUM")[1]),     NIL})
    AAdd(aHeader, {"C5_TIPO",    PadR(oJson["header"]["strategicType"],  TamSX3("C5_TIPO")[1]),    NIL})
    AAdd(aHeader, {"C5_CLIENTE", PadR(oJson["header"]["customer"],       TamSX3("C5_CLIENTE")[1]), NIL})
    AAdd(aHeader, {"C5_LOJACLI", PadR(oJson["header"]["customerBranch"], TamSX3("C5_LOJACLI")[1]), NIL})
    AAdd(aHeader, {"C5_LOJAENT", PadR(oJson["header"]["entryBranch"],    TamSX3("C5_LOJAENT")[1]), NIL})
    AAdd(aHeader, {"C5_CONDPAG", PadR(oJson["header"]["payment"],        TamSX3("C5_CONDPAG")[1]), NIL})

    For nX := 1 To Len(oJson["items"])
        AAdd(aLine, {"C6_ITEM",    PadR(StrZero(nX - 1, 2),            TamSX3("C6_ITEM")[1]),    NIL})
        AAdd(aLine, {"C6_PRODUTO", PadR(oJson["items"][nX]["product"], TamSX3("C6_PRODUTO")[1]), NIL})
        AAdd(aLine, {"C6_QTDVEN",  oJson["items"][nX]["amount"],                                 NIL})
        AAdd(aLine, {"C6_PRCVEN",  oJson["items"][nX]["price"],                                  NIL})
        AAdd(aLine, {"C6_PRUNIT",  oJson["items"][nX]["unityPrice"],                             NIL})
        AAdd(aLine, {"C6_VALOR",   oJson["items"][nX]["total"],                                  NIL})
        AAdd(aLine, {"C6_TES",     PadR(oJson["items"][nX]["tes"],     TamSX3("C6_TES")[1]),     NIL})

        AAdd(aItems, aLine)
        aLine := {}
    Next nX

    aHeader := FwVetByDic(aHeader, "SC5", .F.)
    aLine   := FwVetByDic(aLine,   "SC6", .T.)

    BEGIN SEQUENCE
        MsExecAuto({|x, y, z| MATA410(x, y, z)}, aHeader, aItems, 3)
    END SEQUENCE

    ErrorBlock(bError)

    If (lMsErroAuto .Or. lError)
        lValid := .F.
        SetRestFault(001, "ERROR")
    Else
        ::SetResponse('{"message": "success"}')
    EndIf
Return (lValid)
