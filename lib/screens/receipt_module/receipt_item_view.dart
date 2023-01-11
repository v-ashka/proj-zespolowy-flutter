import 'package:flutter/material.dart';
import 'package:organizerPRO/components/action_box_buttons.dart';
import 'package:organizerPRO/components/appbar.dart';
import 'package:organizerPRO/components/detail_bar.dart';
import 'package:organizerPRO/components/info_box.dart';
import 'package:organizerPRO/constants.dart';
import 'package:organizerPRO/models/file_model.dart';
import 'package:organizerPRO/models/receipt_model.dart';
import 'package:organizerPRO/screens/files_view.dart';
import 'package:organizerPRO/screens/loading_screen.dart';
import 'package:organizerPRO/screens/receipt_module/receipt_list_view.dart';
import 'package:organizerPRO/screens/receipt_module/receipt_form.dart';
import 'package:organizerPRO/services/files_service.dart';
import 'package:organizerPRO/services/receipt_service.dart';
import 'package:organizerPRO/utils/http_delete.dart';

class ReceiptItem extends StatefulWidget {
  String receiptId;
  ReceiptItem({Key? key, required this.receiptId}) : super(key: key);

  @override
  State<ReceiptItem> createState() => _ReceiptItemState();
}

class _ReceiptItemState extends State<ReceiptItem> {
  late ReceiptModel? receiptModel = ReceiptModel();
  String? token;
  bool isGetDataFinished = false;
  late List<FileList>? files = [];
  @override
  void initState() {
    super.initState();
    getData(widget.receiptId);
  }

  getData(id) async {
    token = await storage.read(key: "token");
    receiptModel = (await ReceiptApiService().getReceipt(token, id));
    files = (await FilesService().getFileList(token, id));

    setState(() {
      isGetDataFinished = true;
    });
  }

  String getPhoto(receiptId) {
    return "$SERVER_IP/api/fileUpload/GetFile/$receiptId?naglowkowy=true";
  }

  void showDeleteDialog(isShowing) {
    if (isShowing) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: Text('Usuwam...'),
              content: SizedBox(
                  height: 150,
                  width: 150,
                  child: Center(
                      child: CircularProgressIndicator(color: mainColor))),
            );
          });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isGetDataFinished) return const LoadingScreen();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:
          myAppBar(context, HeaderTitleType.receipt, '-', receiptModel?.nazwa),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 5, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "${receiptModel?.nazwa}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "PODSTAWOWE INFROMACJE",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: fontGrey,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Okres zwrotu: ",
                                    style: TextStyle(
                                      fontFamily: "Lato",
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12,
                                    ),
                                  )),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: secondaryColor),
                                      child: Text(
                                        "${receiptModel?.koniecZwrotu} dni",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Okres gwarancji: ",
                                          style: TextStyle(
                                            fontFamily: "Lato",
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12,
                                          ),
                                        )),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: secondaryColor),
                                        child: Text(
                                            "${receiptModel?.koniecGwarancji} dni",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            DetailBar(title: "Cena", value: "${receiptModel!.cena.toString()} zł"),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: RichText(
                                  text: TextSpan(
                                      text: "DODANO: ",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: fontGrey,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 1.5,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "${receiptModel?.dataZakupu}",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: fontGrey,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1.5,
                                          ),
                                        )
                                      ]),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Stack(
                          alignment: AlignmentDirectional.centerEnd,
                          children: [
                            Positioned(
                              left: 0,
                              child: Container(
                                width: 164,
                                height: 170,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: main25Color,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: main50Color,
                                ),
                                width: 160,
                                height: 170,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      getPhoto(receiptModel?.idParagonu)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              width: 150,
                              height: 170,
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Dane produktu",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "SZCZEGÓŁOWE DANE",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w300,
                                    color: fontGrey,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const Icon(
                            Icons.text_snippet_outlined,
                            size: 65,
                            color: bg100Grey,
                          )
                        ],
                      ),
                      DetailBar(title: "Data zakupu produktu", value: receiptModel!.dataZakupu!),
                      DetailBar(title: "Kategoria produktu", value: receiptModel!.kategoriaParagonu!),
                      DetailBar(title: "Miejsce zakupu", value: receiptModel!.sklep!),
                      if (receiptModel?.uwagi != null && receiptModel?.uwagi != "")
                        DetailBar(title: "Dodatkowe informacje", value: receiptModel!.uwagi!),
                      if (receiptModel?.koniecGwarancji != null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: const [
                              Text(
                                "OKRES WAŻNOŚCI GWARANCJI",
                                style: TextStyle(
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: secondaryColor),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(
                                      "${receiptModel?.koniecGwarancji} dni",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: fontBlack)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InfoBox(
                title: "Zarządzaj swoim paragonem",
                desc: files!.isNotEmpty
                    ? "Ten paragon posiada ${files?.length} pliki umożliwaiające, przejrzenie skorzytaj z jednej z poniższych opcji aby tego dokonać"
                    : "Jeszcze nie dodałeś żadnych plików do swojego paragonu, przejdź do 'Zobacz paragon i pliki' aby dodać nowe dane!",
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ActionBoxButton(
                          icon: Icons.remove_red_eye_outlined,
                          title: "Zobacz paragon i pliki",
                          description:
                              "Wyświetl paragon w postaci zdjęcia bądź PDF.",
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FilesView(
                                      objectId: receiptModel!.idParagonu!),
                                ));
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ActionBoxButton(
                          icon: Icons.edit_outlined,
                          title: "Edytuj paragon",
                          description:
                              "Jeśli dokument wymaga aktualizacji wybierz tę opcję.",
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReceiptForm(
                                    receiptId: receiptModel?.idParagonu,
                                    isEditing: true,
                                  ),
                                ));
                          },
                        ),
                        // const SizedBox(
                        //   height: 15,
                        // ),
                        // ActionBoxButton(
                        //   icon: Icons.file_download_outlined,
                        //   title: "Pobierz paragon",
                        //   description:
                        //       "Pobierz dokument bądź dokumenty bezpośrednio na urządzenie.",
                        //   onPressed: () async {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => ReceiptForm(
                        //             receiptId: receiptModel?.idParagonu,
                        //             isEditing: true,
                        //           ),
                        //         ));
                        //   },
                        // ),
                        const SizedBox(
                          height: 15,
                        ),
                        ActionBoxButton(
                          icon: Icons.delete_outline,
                          title: "Usuń paragon",
                          description:
                              "Opcja ta spowoduje całkowtie usunięcie dokumentu z twojego konta.",
                          backgroundColor: deleteBtn,
                          onPressed: () async {
                            Navigator.of(context).pop();
                            showDeleteDialog(true);

                            bool response = await deleteRecord(
                                Endpoints.receiptDefault,
                                token,
                                receiptModel?.idParagonu);

                            if (response) {
                              showDeleteDialog(false);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        ReceiptList(),
                                  ),
                                  ModalRoute.withName("/dashboard"));
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
