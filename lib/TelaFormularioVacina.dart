import 'package:aplicativo/TelaFormulario.dart';
import 'package:aplicativo/TelaVacinador.dart';
import 'package:flutter/material.dart';
import 'package:aplicativo/TelaFormularioVacina.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:select_form_field/select_form_field.dart';
import 'conexaoFirestore.dart';
import 'TelaFormularioVacina.dart';

class TelaVacina extends StatefulWidget {
  TelaVacina(this.vacinado, {Key? key}) : super(key: key);
  Map<String, dynamic> vacinado;
  @override
  _TelaVacinaState createState() => _TelaVacinaState();
}

class _TelaVacinaState extends State<TelaVacina> {
  bool segundaDose = false;
  final _formKey = GlobalKey<FormState>();
  bool botao = false;
  String? dropdownValueVacina, dropdownValueOcupacao, dropdownValueLote;
  Map<String, dynamic> dose = {};

  Widget _dataAprazamento(vacina, data, dose) {
    if (dose == '1') {
      if (vacina == null)
        return TextFormField(
          enabled: false,
          decoration: InputDecoration(
              //labelText: 'Data de aprazamento',
              hintText: 'Para a data de aprazamento, selecione uma vacina.'),
        );
      else if (vacina == 'CORONAVAC')
        return TextFormField(
          enabled: false,
          decoration: InputDecoration(
              helperText: 'Data de aprazamento',
              hintText: DateFormat('dd/MM/yyyy')
                  .format(data.add(Duration(days: 28)))), // CORONAVAC: 28 dias
        );
      else if (vacina == 'ASTRAZENECA/OXFORD/FIOCRUZ')
        return TextFormField(
          enabled: false,
          decoration: InputDecoration(
              helperText: 'Data de aprazamento',
              hintText: DateFormat('dd/MM/yyyy').format(
                  data.add(Duration(days: 84)))), // ASTRAZENECA: 84 dias
        );
      else if (vacina == 'PFIZER')
        return TextFormField(
          enabled: false,
          decoration: InputDecoration(
              helperText: 'Data de aprazamento',
              hintText: DateFormat('dd/MM/yyyy')
                  .format(data.add(Duration(days: 84)))), // PFIZER: 84 dias
        );
      else if (vacina == 'JANSSEN')
        return TextFormField(
          enabled: false,
          decoration: InputDecoration(
              helperText: 'Data de aprazamento',
              hintText: 'DOSE UNICA'), // PFIZER: 84 dias
        );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    Size tamanhoDispositivo = MediaQuery.of(context).size;
    final format = DateFormat("dd/MM/yyyy");
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela de Formulário - Vacina"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          height: tamanhoDispositivo.height * 0.85,
          width: tamanhoDispositivo.height * 0.8,
          // decoration: BoxDecoration(border: Border.all()),
          padding: EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: [
                      Spacer(),
                      Text('Registrar 1ª dose'),
                      Switch(
                          value: botao,
                          onChanged: (_) => setState(() {
                                botao = !botao;
                                widget.vacinado['numeroDose'] =
                                    botao ? '2' : '1';
                              })),
                      Text('Registrar 2ª dose'),
                      Spacer(),
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    validator: (value) =>
                        value == null ? 'Preencha a vacina.' : null,
                    value: dropdownValueVacina,
                    hint: Text('Selecione a vacina a ser aplicada'),
                    dropdownColor: Colors.lightGreen[100],
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValueVacina = newValue!;
                        dose['Vacina'] = dropdownValueVacina;
                      });
                    },
                    items: <String>[
                      'ASTRAZENECA/OXFORD/FIOCRUZ',
                      'CORONAVAC',
                      'JANSSEN',
                      'PFIZER',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<String>(
                    validator: (value) =>
                        value == null ? 'Preencha o lote.' : null,
                    isExpanded: true,
                    value: dropdownValueLote,
                    hint: Text('Lote'),
                    dropdownColor: Colors.lightGreen[100],
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValueLote = newValue!;
                        dose['Lote'] = dropdownValueLote;
                      });
                    },
                    items: <String>[
                      'L50000',
                      'L50001',
                      'L50002',
                      'L50003',
                      'L50004',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<String>(
                    validator: (value) => value == null
                        ? 'Preencha o grupo de atendimento.'
                        : null,
                    isExpanded: true,
                    value: dropdownValueOcupacao,
                    hint: Text('Grupo de atendimento'),
                    dropdownColor: Colors.lightGreen[100],
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValueOcupacao = newValue!;
                        widget.vacinado['Grupo'] = dropdownValueOcupacao;
                      });
                    },
                    items: <String>[
                      'AEROVIARIOS',
                      'COMORBIDADE',
                      'ESTUDO CLINICO',
                      'IDOSO',
                      'IDOSO EM ILPI',
                      'INDIGENAS',
                      'METROVIARIOS/CPTM',
                      'MOTORISTAS E COBRADORES DE ONIBUS',
                      'PESSOA >= 18 ANOS PORTADORA DE DEFICIENCIA RESIDENTES EM RI',
                      'PESSOA COM DEFICIENCIA',
                      'PESSOA COM DEFICIENCIA PERMANENTE SEVERA',
                      'POPULACAO EM GERAL',
                      'POPULACAO EM SITUACAO DE RUA',
                      'PORTUARIOS',
                      'QUILOMBOLA',
                      'RIBEIRINHAS',
                      'TRABALHADOR DA EDUCACAO',
                      'TRABAHADOR DA SEGURANCA PUBLICA',
                      'TRABALHADOR DE SAUDE',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DateTimeField(
                    initialValue: DateTime.now(),
                    decoration: InputDecoration(hintText: "Data de aplicação"),
                    onChanged: (input) =>
                        setState(() => widget.vacinado['Data'] = input),
                    format: format,
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(2021),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2022));
                    },
                  ),
                  _dataAprazamento(dose['Vacina'], widget.vacinado['Data'],
                      widget.vacinado['numeroDose']),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          if (_formKey.currentState!.validate()) {
                            dose['Data'] = widget.vacinado['Data'];
                            widget.vacinado['Dose'] = dose;
                            registroVacinado(widget.vacinado);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TelaVacinador()),
                              (Route<dynamic> route) => false,
                            );
                          }
                        });
                      },
                      child: Text('Enviar'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
