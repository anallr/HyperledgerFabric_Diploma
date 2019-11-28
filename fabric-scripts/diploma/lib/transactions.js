/*Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License. */

/* global getAssetRegistry getFactory emit */

/**
 * Sample transaction processor function.
 * @param {poc2.transactions.Graduation} tx Students Graduation
 * @returns {poc2.assets.Diploma} All the diplomas.
 * @transaction
*/
async function graduation(tx) {  
  
    const allStudents = await getParticipantRegistry('poc2.participants.Student');
    const localStudents = await allStudents.getAll();
    const allDiplomas = await getAssetRegistry('poc2.assets.Diploma');
    const localDiplomas = await allDiplomas.getAll();
    var factory = getFactory();
    
    const unit = tx.unit; //unidade da graduacao
    const coleg = tx.coleg; //colegiado da graduacao

    for (const student of localStudents) {
        let randomId = getRandomInt().toString();
        let createDiploma = true;
      if (student.graduated == true){
          for (const diploma of localDiplomas) {
              if (student.id == diploma.owner.$identifier) {
              //eh graduado e possui diploma
                createDiploma = false;
                break;
              }
          }
            if (createDiploma == true && student.coleg.$identifier == coleg.id){
                var timestamp = new Date(new Date().getTime());
                var newDiploma = factory.newResource('poc2.assets', 'Diploma', randomId);
                newDiploma.owner = student;
                newDiploma.unit = unit;
                newDiploma.coleg = coleg;
                newDiploma.createdAt = timestamp;
                await allDiplomas.add(newDiploma);
          }
      }
  }
    return allDiplomas;
}

function getRandomInt() {
    let min = Math.ceil(1);
    let max = Math.floor(1000000);
    return Math.floor(Math.random() * (max - min)) + min;
}