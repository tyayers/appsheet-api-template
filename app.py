import pprint
from proto import fields
import web
import json
import logging
import urllib
import requests
import io
import os
import os.path

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import google.auth

urls = (
  '/notes(.*)', 'notes',
  '/', 'openapispec'
)
app = web.application(urls, globals())

if not firebase_admin._apps:
  cred = credentials.ApplicationDefault()
  firebase_admin.initialize_app(cred, {
    'projectId': cred.project_id,
  })

class notes:

  db = firestore.client()
  
  # Returns all of the notes
  def GET(self, id):

    new_result = {}

    if len(id) == 0:
      forms_ref = self.db.collection('notes')
      forms = forms_ref.stream()
      new_result = {
        "notes": []
      }

      for form in forms:
        new_result["notes"].append(form.to_dict())
    else:
      doc_ref = self.db.collection('notes').document(id[1:])
      doc = doc_ref.get()
      new_result = doc.to_dict()

    if new_result:
      web.header('Content-Type', 'application/json')
      return json.dumps(new_result)
    else:
      return web.notfound("Not found")

  # Posts a new note to be stored
  def POST(self, name):

    data = json.loads(web.data())

    logging.info(json.dumps(data))

    self.db.collection('notes').document(data["id"]).set(data)

    pprint.pprint(data)

    web.header('Content-Type', 'application/json')
    return json.dumps(data)

  # Puts a note to be updated
  def PUT(self, name):

    data = json.loads(web.data())

    logging.info(json.dumps(data))

    self.db.collection('notes').document(data["id"]).set(data)

    pprint.pprint(data)

    web.header('Content-Type', 'application/json')
    return json.dumps(data)

  # Delets a note
  def DELETE(self, id):
    if id:
      self.db.collection(u'notes').document(id[1:]).delete()
    
    return "200 OK"

# Returns the OpenAPI spec, filled in with the current server
class openapispec:

  #Returns the OpenAPI spec, filled in with the current server
  def GET(self):
    f = open("apispec.yaml", "r")
    spec = f.read()
    spec = spec.replace("SERVER_URL", web.ctx.home.replace("http://", "https://"))
    web.header('Content-Type', 'text/plain;charset=UTF-8')
    return spec

if __name__ == "__main__":
  app.run()
