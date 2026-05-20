package com.licenta.foodtrack.service;

import com.licenta.foodtrack.dto.HealthConnectRequest;
import com.licenta.foodtrack.dto.InregistrareActivitateFizicaRequest;
import com.licenta.foodtrack.dto.InregistrareActivitateFizicaResponse;
import com.licenta.foodtrack.dto.ModificaInregistrareActivitateFizicaRequest;
import com.licenta.foodtrack.mapper.InregistrareActivitateFizicaMapper;
import com.licenta.foodtrack.model.ActivitateFizica;
import com.licenta.foodtrack.model.InregistrareActivitateFizica;
import com.licenta.foodtrack.model.SursaDate;
import com.licenta.foodtrack.model.Utilizator;
import com.licenta.foodtrack.repository.ActivitateFizicaRepository;
import com.licenta.foodtrack.repository.InregistrariActivitatiFiziceRepository;
import com.licenta.foodtrack.repository.UtilizatorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ActivitateFizicaService {

    private final ActivitateFizicaRepository activitateFizicaRepository;
    private final InregistrariActivitatiFiziceRepository inregistrariActivitatiFiziceRepository;
    private final InregistrareActivitateFizicaMapper inregistrareActivitateFizicaMapper;
    private final UtilizatorRepository utilizatorRepository;

    public InregistrareActivitateFizicaResponse adaugaInregistrareActivitateFizica(
            InregistrareActivitateFizicaRequest request,
            UUID idUtilizator) {

        Utilizator utilizator = utilizatorRepository.findById(idUtilizator)
                .orElseThrow(() -> new IllegalStateException("Utilizatorul cu id-ul " + idUtilizator + " nu a fost găsit."));

        ActivitateFizica activitateFizica = activitateFizicaRepository.findById(request.id())
                .orElseThrow(() -> new IllegalStateException("Activitatea fizica cu id-ul " + request.id() + " nu a fost găsită."));

        InregistrareActivitateFizica inregistrareActivitateFizica =
                inregistrareActivitateFizicaMapper.toInregistrareActivitateFizica(activitateFizica,request);


        inregistrareActivitateFizica.setCaloriiArse(ActivitateFizica.calculeazaCaloriiArse(
                inregistrareActivitateFizica.getMet(),
                utilizator.getMasuratoareGreutateFor(request.dataActivitate()).get(),
                inregistrareActivitateFizica.getDurataMin()));

        inregistrareActivitateFizica.setSursaDate(SursaDate.MANUAL);
        inregistrareActivitateFizica.setUtilizator(utilizator);


        return inregistrareActivitateFizicaMapper
                .toResponse(inregistrariActivitatiFiziceRepository.save(inregistrareActivitateFizica));
    }

    public InregistrareActivitateFizicaResponse modificaInregistrareActivitateFizica(
            ModificaInregistrareActivitateFizicaRequest request,
            UUID utilizatorId) {

        Utilizator utilizator = utilizatorRepository.findById(utilizatorId)
                .orElseThrow(() -> new IllegalStateException("Utilizatorul cu id-ul " + utilizatorId + " nu a fost găsit."));

        InregistrareActivitateFizica inregistrareActivitateFizica =
                inregistrariActivitatiFiziceRepository
                        .findByIdAndUtilizatorIdAndSursaDate(request.id(), utilizator.getId(), SursaDate.MANUAL)
                .orElseThrow(() ->
                        new IllegalStateException("Înregistrarea activității fizice cu id-ul "
                                + request.id() + " nu a fost găsită."));

        inregistrareActivitateFizica.setDurataMin(request.durataMin());
        inregistrareActivitateFizica.setCaloriiArse(ActivitateFizica.calculeazaCaloriiArse(
                inregistrareActivitateFizica.getMet(),
                utilizator.getMasuratoareGreutateFor(inregistrareActivitateFizica.getDataActivitate()).get(),
                inregistrareActivitateFizica.getDurataMin()));

        return inregistrareActivitateFizicaMapper
                .toResponse(inregistrariActivitatiFiziceRepository.save(inregistrareActivitateFizica));
    }

    public void stergeInregistrareActivitateFizica(Long id, UUID utilizatorId) {

        InregistrareActivitateFizica inregistrareActivitateFizica =
                inregistrariActivitatiFiziceRepository
                        .findByIdAndUtilizatorIdAndSursaDate(id, utilizatorId, SursaDate.MANUAL)
                .orElseThrow(() -> new IllegalStateException("Înregistrarea activității fizice cu id-ul "
                        + id + " nu a fost găsită."));

        inregistrariActivitatiFiziceRepository.delete(inregistrareActivitateFizica);
    }

    public InregistrareActivitateFizicaResponse adaugaInregistrareHealthConnect(HealthConnectRequest request, UUID utilizatorId) {

        Utilizator utilizator = utilizatorRepository.findById(utilizatorId)
                .orElseThrow(() -> new IllegalStateException("Utilizatorul cu id-ul " + utilizatorId + " nu a fost găsit."));

        InregistrareActivitateFizica inregistrareHealthConnect =
                inregistrariActivitatiFiziceRepository.findFirstByUtilizatorIdAndSursaDateAndDataActivitate(
                                utilizatorId, SursaDate.HEALTH_CONNECT, request.dataActivitate())
                .orElse(new InregistrareActivitateFizica());

        inregistrareHealthConnect.setCaloriiArse(request.caloriiArse());
        inregistrareHealthConnect.setNumarPasi(request.numarPasi());
        inregistrareHealthConnect.setDataActivitate(request.dataActivitate());
        inregistrareHealthConnect.setSursaDate(SursaDate.HEALTH_CONNECT);
        inregistrareHealthConnect.setNume("Health Connect");
        inregistrareHealthConnect.setUtilizator(utilizator);

        return inregistrareActivitateFizicaMapper
                .toResponse(inregistrariActivitatiFiziceRepository.save(inregistrareHealthConnect));
    }
}
