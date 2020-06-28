import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:todo/models/ussd_codes.dart';

class MockClient extends Mock implements http.Client {}

Future<String> fetchHash(http.Client client) async {
  final resp = await http.get(
    'https://todo-devs.github.io/todo-json/hash.json',
    headers: {
      'Accept-Encoding': 'gzip, deflate, br',
    },
  );
  if (resp.statusCode == 200) {
    var json = jsonDecode(resp.body);
    var hash = json['hash'];
    return hash;
  } else {
    throw Exception("Error al cargar el hash");
  }
}

Future<String> fetchUssdConfig(http.Client client) async {
  final resp = await http.get(
    'https://todo-devs.github.io/todo-json/config.json',
    headers: {
      'Accept-Encoding': 'gzip, deflate, br',
    },
  );
  if (resp.statusCode == 200) {
    var body = utf8.decode(resp.bodyBytes);

    return body;
  } else {
    throw Exception("Error al cargar el hash");
  }
}

main() {
  group("Flujo de descarga de los codigos USSD", () {
    test("Retorna el hash", () async {
      final client = MockClient();

      // Mockito para devolver una respuesta exitosa cuando llama al
      // http.Client proporcionado.
      when(client.get('https://todo-devs.github.io/todo-json/hash.json'))
          .thenAnswer(
        (_) async => http.Response("""
          {
              "hash":"44cfca8f4f10aed9759043198f0f92917a559a7f"
          }
          """, 200),
      );

      expect(
          await fetchHash(client), "44cfca8f4f10aed9759043198f0f92917a559a7f");
    });

    test("Retorna el objeto body con las configuraciones del fichero json",
        () async {
      final client = MockClient();
      when(client.get('https://todo-devs.github.io/todo-json/config.json'))
          .thenAnswer(
        (_) async => http.Response("""
          {
            "items": [
              {
                "name": "Consultar saldo",
                "description": "Consulte su saldo actual",
                "icon": "attach_money",
                "type": "code",
                "fields": [],
                "code": "*222#"
              },
              {
                "name": "Consultar datos",
                "description": "Consultar los megas disponibles",
                "icon": "data_usage",
                "type": "code",
                "fields": [],
                "code": "*222*328#"
              },
              {
                "name": "Consultar bono",
                "description": "Consulte el saldo actual de su Bono",
                "icon": "star_border",
                "type": "code",
                "fields": [],
                "code": "*222*266#"
              },
              {
                "name": "Asterisco 99",
                "description": "Llamadas con pago revertido",
                "icon": "call",
                "type": "code",
                "fields": [
                  {
                    "name": "telefono",
                    "type": "phone_number"
                  }
                ],
                "code": "*99{telefono}"
              },
              {
                "name": "Gestionar Llamadas",
                "description": "Realice llamadas de manera fácil",
                "icon": "call",
                "type": "category",
                "items": [
                  {
                    "name": "Asterisco 99",
                    "description": "Llamadas con pago revertido",
                    "icon": "call",
                    "type": "code",
                    "fields": [
                      {
                        "name": "telefono",
                        "type": "phone_number"
                      }
                    ],
                    "code": "*99{telefono}"
                  },
                  {
                    "name": "Mi número oculto",
                    "description": "Llame sin mostrar su número",
                    "icon": "call",
                    "type": "code",
                    "fields": [
                      {
                        "name": "telefono",
                        "type": "phone_number"
                      }
                    ],
                    "code": "#31#{telefono}"
                  },
                  {
                    "name": "Números útiles",
                    "description": "Ambulancia, Bomberos, Policía, Etc.",
                    "icon": "call",
                    "type": "category",
                    "items": [
                      {
                        "name": "2266 - Atención al cliente",
                        "description": "",
                        "icon": "call",
                        "type": "code",
                        "fields": [],
                        "code": "2266"
                      },
                      {
                        "name": "103 - Línea Antidrogas",
                        "description": "",
                        "icon": "call",
                        "type": "code",
                        "fields": [],
                        "code": "103"
                      },
                      {
                        "name": "104 - Ambulancias",
                        "description": "",
                        "icon": "call",
                        "type": "code",
                        "fields": [],
                        "code": "104"
                      },
                      {
                        "name": "105 - Bomberos",
                        "description": "",
                        "icon": "call",
                        "type": "code",
                        "fields": [],
                        "code": "105"
                      },
                      {
                        "name": "106 - Policía",
                        "description": "",
                        "icon": "call",
                        "type": "code",
                        "fields": [],
                        "code": "106"
                      },
                      {
                        "name": "107 - Salvamento Marítimo",
                        "description": "",
                        "icon": "call",
                        "type": "code",
                        "fields": [],
                        "code": "107"
                      },
                      {
                        "name": "118 - Cubacel Info",
                        "description": "",
                        "icon": "call",
                        "type": "code",
                        "fields": [],
                        "code": "118"
                      }
                    ]
                  }
                ]
              },
              {
                "name": "Gestionar Saldo",
                "description": "Gestione el balance de su línea",
                "icon": "attach_money",
                "type": "category",
                "items": [
                  {
                    "name": "Saldo",
                    "description": "Consulte su saldo actual",
                    "icon": "attach_money",
                    "type": "code",
                    "fields": [],
                    "code": "*222#"
                  },
                  {
                    "name": "Recargar",
                    "description": "Recarge su línea fácilmente",
                    "icon": "monetization_on",
                    "type": "code",
                    "fields": [
                      {
                        "name": "numero tarjeta",
                        "type": "card_number"
                      }
                    ],
                    "code": "*662*{numero tarjeta}#"
                  },
                  {
                    "name": "Adelantar Saldo",
                    "description": "Recargue con un adelanto de saldo",
                    "icon": "monetization_on",
                    "type": "category",
                    "items": [
                      {
                        "name": "1 CUC",
                        "description": "Adelantar con  1.00 CUC de saldo",
                        "icon": "monetization_on",
                        "type": "code",
                        "fields": [],
                        "code": "*234*3*1*1#"
                      },
                      {
                        "name": "2 CUC",
                        "description": "Adelantar con  2.00 CUC de saldo",
                        "icon": "monetization_on",
                        "type": "code",
                        "fields": [],
                        "code": "*234*3*1*2#"
                      }
                    ]
                  },
                  {
                    "name": "Transferir Saldo",
                    "description": "Transferir saldo a otro",
                    "icon": "mobile_screen_share",
                    "type": "code",
                    "fields": [
                      {
                        "name": "telefono",
                        "type": "phone_number"
                      },
                      {
                        "name": "cantidad",
                        "type": "money"
                      },
                      {
                        "name": "clave",
                        "type": "key_number"
                      }
                    ],
                    "code": "*234*1*{telefono}*{clave}*{cantidad}#"
                  },
                  {
                    "name": "Bono",
                    "description": "Consulte el saldo actual de su Bono",
                    "icon": "star_border",
                    "type": "code",
                    "fields": [],
                    "code": "*222*266#"
                  }
                ]
              },
              {
                "name": "Gestionar Planes",
                "description": "Planes de Datos, Voz, Sms, y Amigo",
                "icon": "shopping_cart",
                "type": "category",
                "items": [
                  {
                    "name": "Planes de Datos",
                    "description": "Gestione su plan de datos",
                    "icon": "data_usage",
                    "type": "category",
                    "items": [
                      {
                        "name": "Megas disponibles",
                        "description": "Consultar los megas disponibles",
                        "icon": "data_usage",
                        "type": "code",
                        "fields": [],
                        "code": "*222*328#"
                      },
                      {
                        "name": "Tarifa por consumo",
                        "description": "Consumo directo del saldo",
                        "icon": "network_cell",
                        "type": "category",
                        "items": [
                          {
                            "name": "Habilitar",
                            "description": "",
                            "icon": "network_cell",
                            "type": "code",
                            "fields": [],
                            "code": "*133*1*1*1#"
                          },
                          {
                            "name": "Deshabilitar",
                            "description": "",
                            "icon": "network_locked",
                            "type": "code",
                            "fields": [],
                            "code": "*133*1*1*2#"
                          }
                        ]
                      },
                      {
                        "name": "Bolsa Correo",
                        "description": "Comprar plan sólo para correo nauta",
                        "icon": "mail",
                        "type": "code",
                        "fields": [],
                        "code": "*133*1*2#"
                      },
                      {
                        "name": "Paquetes con 4G",
                        "description": "Paquetes de internet para usuarios que han activado 4G",
                        "icon": "data_usage",
                        "type": "category",
                        "items": [
                          {
                            "name": "Bolsa Diaria LTE",
                            "description": "Paquete de 200MB por 1 CUC vence en 24h",
                            "icon": "data_usage",
                            "type": "code",
                            "fields": [],
                            "code": "*133*1*3#"
                          },
                          {
                            "name": "400MB - 5 CUC",
                            "description": "Paquete de 400MB por 5 CUC (+500MB bono 4G)",
                            "icon": "data_usage",
                            "type": "code",
                            "fields": [],
                            "code": "*133*1*4*1#"
                          },
                          {
                            "name": "600MB - 7 CUC",
                            "description": "Paquete de 600MB por 7 CUC (+800MB bono 4G)",
                            "icon": "data_usage",
                            "type": "code",
                            "fields": [],
                            "code": "*133*1*4*2#"
                          },
                          {
                            "name": "1GB - 10 CUC",
                            "description": "Paquete de 1GB por 10 CUC (+1.5GB bono 4G)",
                            "icon": "data_usage",
                            "type": "code",
                            "fields": [],
                            "code": "*133*1*4*3#"
                          },
                          {
                            "name": "2.5GB - 20 CUC",
                            "description": "Paquete de 2.5GB por 20 CUC (+3GB bono 4G)",
                            "icon": "data_usage",
                            "type": "code",
                            "fields": [],
                            "code": "*133*1*4*4#"
                          },
                          {
                            "name": "4GB - 30 CUC",
                            "description": "Paquete de 4GB por 30 CUC (+5GB bono 4G)",
                            "icon": "data_usage",
                            "type": "code",
                            "fields": [],
                            "code": "*133*1*4*5#"
                          },
                          {
                            "name": "1GB - 4 CUC",
                            "description": "Paquete de 1GB por 4 CUC (sólo 4G)",
                            "icon": "data_usage",
                            "type": "code",
                            "fields": [],
                            "code": "*133*1*5*1#"
                          },
                          {
                            "name": "2.5GB - 8 CUC",
                            "description": "Paquete LTE de 2.5GB por 8 CUC (sólo 4G)",
                            "icon": "data_usage",
                            "type": "code",
                            "fields": [],
                            "code": "*133*1*5*2#"
                          },
                          {
                            "name": "14GB - 45 CUC",
                            "description": "Paquete LTE 14GB por 45 CUC (sólo 4G)",
                            "icon": "data_usage",
                            "type": "code",
                            "fields": [],
                            "code": "*133*1*5*3#"
                          }
                        ]
                      },
                      {
                        "name": "Paquetes solo 3G",
                        "description": "Paquetes de internet para usuarios que no han activado 4G",
                        "icon": "data_usage",
                        "type": "category",
                        "items": [
                          {
                            "name": "Paquete 400 MB - 5 CUC",
                            "description": "Paquete de 400MB por 5 CUC",
                            "icon": "data_usage",
                            "type": "code",
                            "fields": [],
                            "code": "*133*1*3*1#"
                          },
                          {
                            "name": "Paquete 600 MB - 7 CUC",
                            "description": "Paquete de 600MB por 7 CUC",
                            "icon": "data_usage",
                            "type": "code",
                            "fields": [],
                            "code": "*133*1*3*2#"
                          },
                          {
                            "name": "Paquete 1GB - 10 CUC",
                            "description": "Paquete de 1GB por 10 CUC",
                            "icon": "data_usage",
                            "type": "code",
                            "fields": [],
                            "code": "*133*1*3*3#"
                          },
                          {
                            "name": "Paquete 2.5GB - 20 CUC",
                            "description": "Paquete de 2.5GB por 20 CUC",
                            "icon": "data_usage",
                            "type": "code",
                            "fields": [],
                            "code": "*133*1*3*4#"
                          },
                          {
                            "name": "Paquete 4GB - 30 CUC",
                            "description": "Paquete de 4GB por 30 CUC",
                            "icon": "data_usage",
                            "type": "code",
                            "fields": [],
                            "code": "*133*1*3*5#"
                          }
                        ]
                      }
                    ]
                  },
                  {
                    "name": "Planes de voz",
                    "description": "Gestione su plan de voz",
                    "icon": "phone_in_talk",
                    "type": "category",
                    "items": [
                      {
                        "name": "Saldo",
                        "description": "Consultar el tiempo disponible",
                        "icon": "phone_in_talk",
                        "type": "code",
                        "fields": [],
                        "code": "*222*869#"
                      },
                      {
                        "name": "5 min",
                        "description": "Plan de 5 min por 1.50 CUC (0.30 por min)",
                        "icon": "phone_in_talk",
                        "type": "code",
                        "fields": [],
                        "code": "*133*3*1#"
                      },
                      {
                        "name": "10 min",
                        "description": "Plan de 10 min por 2.90 CUC (0.29 por min)",
                        "icon": "phone_in_talk",
                        "type": "code",
                        "fields": [],
                        "code": "*133*3*2#"
                      },
                      {
                        "name": "15 min",
                        "description": "Plan de 15 min por 4.20 CUC (0.28 por min)",
                        "icon": "phone_in_talk",
                        "type": "code",
                        "fields": [],
                        "code": "*133*3*3#"
                      },
                      {
                        "name": "25 min",
                        "description": "Plan de 25 min por 6.50 CUC (0.26 por min)",
                        "icon": "phone_in_talk",
                        "type": "code",
                        "fields": [],
                        "code": "*133*3*4#"
                      },
                      {
                        "name": "40 min",
                        "description": "Plan de 40 min por 10 CUC (0.25 por min)",
                        "icon": "phone_in_talk",
                        "type": "code",
                        "fields": [],
                        "code": "*133*3*5#"
                      }
                    ]
                  },
                  {
                    "name": "Planes de SMS",
                    "description": "Gestione su plan de SMS",
                    "icon": "sms",
                    "type": "category",
                    "items": [
                      {
                        "name": "Saldo",
                        "description": "Consultar los SMS disponibles",
                        "icon": "sms",
                        "type": "code",
                        "fields": [],
                        "code": "*222*767#"
                      },
                      {
                        "name": "10 sms",
                        "description": "10 SMS nacionales por 0.70 CUC",
                        "icon": "sms",
                        "type": "code",
                        "fields": [],
                        "code": "*133*2*1#"
                      },
                      {
                        "name": "20 sms",
                        "description": "20 SMS nacionales por 1.30 CUC",
                        "icon": "sms",
                        "type": "code",
                        "fields": [],
                        "code": "*133*2*2#"
                      },
                      {
                        "name": "35 sms",
                        "description": "35 SMS nacionales por 2.10 CUC",
                        "icon": "sms",
                        "type": "code",
                        "fields": [],
                        "code": "*133*2*3#"
                      },
                      {
                        "name": "45 sms",
                        "description": "45 SMS nacionales por 2.50 CUC",
                        "icon": "sms",
                        "type": "code",
                        "fields": [],
                        "code": "*133*2*4#"
                      }
                    ]
                  },
                  {
                    "name": "Plan amigos",
                    "description": "Gestione sus números amigos",
                    "icon": "people",
                    "type": "category",
                    "items": [
                      {
                        "name": "Estado",
                        "description": "Consultar el estado del plan",
                        "icon": "people",
                        "type": "code",
                        "fields": [],
                        "code": "*222*264#"
                      },
                      {
                        "name": "Activar",
                        "description": "Activar el plan",
                        "icon": "offline_pin",
                        "type": "code",
                        "fields": [],
                        "code": "*133*4*1*1#"
                      },
                      {
                        "name": "Desactivar",
                        "description": "Desactivar el plan",
                        "icon": "cancel",
                        "type": "code",
                        "fields": [],
                        "code": "*133*4*1*2#"
                      },
                      {
                        "name": "Agregar amigo",
                        "description": "Agregar el número de un amigo",
                        "icon": "add_circle_outline",
                        "type": "code",
                        "fields": [
                          {
                            "name": "telefono",
                            "type": "phone_number"
                          }
                        ],
                        "code": "*133*4*2*1*{telefono}#"
                      },
                      {
                        "name": "Eliminar amigo",
                        "description": "Eliminar el número de un amigo",
                        "icon": "remove_circle_outline",
                        "type": "code",
                        "fields": [
                          {
                            "name": "telefono",
                            "type": "phone_number"
                          }
                        ],
                        "code": "*133*4*2*2*{telefono}#"
                      },
                      {
                        "name": "Lista de amigos",
                        "description": "Consulte la lista de números amigos",
                        "icon": "list",
                        "type": "code",
                        "fields": [],
                        "code": "*133*4*3#"
                      }
                    ]
                  }
                ]
              },
              {
                "name": "Línea corporativa",
                "description": "Consulte el estado de planes corporativos",
                "icon": "monetization_on",
                "type": "code",
                "fields": [],
                "code": "*111#"
              }
            ]
          }
          """, 200),
      );
      var body = await fetchUssdConfig(client);
      var parsedJson = jsonDecode(body);
      expect(UssdRoot.fromJson(parsedJson), isA<UssdRoot>());
    });

    test(
        "Almacena el hash actual y comprueba si es desigual del anterior para permitir realizar la descarga del body config.json",
        () async {
      final client = MockClient();

      SharedPreferences.setMockInitialValues({"hash": "hashold"});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var lastHash = prefs.getString('hash');
      var actualHash = await fetchHash(client);
      if (actualHash != lastHash) {
        var body = await fetchUssdConfig(client);
        prefs.setString('hash', actualHash);
        prefs.setString('config', body);
        expect(actualHash, prefs.getString('hash'));
      }
    });
  });
}
