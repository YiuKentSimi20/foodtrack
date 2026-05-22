package com.licenta.foodtrack.service;

import com.licenta.foodtrack.dto.*;
import com.licenta.foodtrack.mapper.ActivitateFizicaMapper;
import com.licenta.foodtrack.mapper.InregistrareActivitateFizicaMapper;
import com.licenta.foodtrack.model.ActivitateFizica;
import com.licenta.foodtrack.model.InregistrareActivitateFizica;
import com.licenta.foodtrack.model.SursaDate;
import com.licenta.foodtrack.model.Utilizator;
import com.licenta.foodtrack.repository.ActivitateFizicaRepository;
import com.licenta.foodtrack.repository.InregistrareActivitateFizicaRepository;
import com.licenta.foodtrack.repository.UtilizatorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ActivitateFizicaService {

    private final ActivitateFizicaRepository activitateFizicaRepository;
    private final InregistrareActivitateFizicaRepository inregistrareActivitateFizicaRepository;
    private final InregistrareActivitateFizicaMapper inregistrareActivitateFizicaMapper;
    private final UtilizatorRepository utilizatorRepository;
    private final ActivitateFizicaMapper activitateFizicaMapper;

    public List<ActivitateFizicaDto> getActivitatiFizice(UUID id) {

        return activitateFizicaRepository.findAll().stream()
                .map(activitateFizicaMapper::toDto)
                .toList();
    }

    public InregistrareActivitateFizicaResponse adaugaInregistrareActivitateFizica(
            InregistrareActivitateFizicaRequest request,
            UUID idUtilizator) {

        Utilizator utilizator = utilizatorRepository.findById(idUtilizator)
                .orElseThrow(() -> new IllegalStateException("Utilizatorul cu id-ul " + idUtilizator + " nu a fost găsit."));

        ActivitateFizica activitateFizica = activitateFizicaRepository.findById(request.id())
                .orElseThrow(() -> new IllegalStateException("Activitatea fizica cu id-ul " + request.id() + " nu a fost găsită."));

        InregistrareActivitateFizica inregistrareActivitateFizica =
                inregistrareActivitateFizicaMapper.toInregistrareActivitateFizica(activitateFizica, request);

        inregistrareActivitateFizica.setUtilizatorKg(utilizator.getMasuratoareGreutateFor(request.dataActivitate()).orElseThrow(() ->
                new IllegalStateException("Nu s-a găsit o măsurătoare a greutății pentru data activității fizice.")));

        inregistrareActivitateFizica.setCaloriiArse(ActivitateFizica.calculeazaCaloriiArse(
                inregistrareActivitateFizica.getMet(),
                inregistrareActivitateFizica.getUtilizatorKg(),
                inregistrareActivitateFizica.getDurataMin()));

        inregistrareActivitateFizica.setSursaDate(SursaDate.MANUAL);
        inregistrareActivitateFizica.setUtilizator(utilizator);


        return inregistrareActivitateFizicaMapper
                .toResponse(inregistrareActivitateFizicaRepository.save(inregistrareActivitateFizica));
    }

    public InregistrareActivitateFizicaResponse modificaInregistrareActivitateFizica(
            ModificaInregistrareActivitateFizicaRequest request,
            UUID utilizatorId) {

        Utilizator utilizator = utilizatorRepository.findById(utilizatorId)
                .orElseThrow(() -> new IllegalStateException("Utilizatorul cu id-ul " + utilizatorId + " nu a fost găsit."));

        InregistrareActivitateFizica inregistrareActivitateFizica =
                inregistrareActivitateFizicaRepository
                        .findByIdAndUtilizatorIdAndSursaDate(request.id(), utilizator.getId(), SursaDate.MANUAL)
                        .orElseThrow(() ->
                                new IllegalStateException("Înregistrarea activității fizice cu id-ul "
                                        + request.id() + " nu a fost găsită."));

        inregistrareActivitateFizica.setDurataMin(request.durataMin());
        inregistrareActivitateFizica.setCaloriiArse(ActivitateFizica.calculeazaCaloriiArse(
                inregistrareActivitateFizica.getMet(),
                utilizator.getMasuratoareGreutateFor(inregistrareActivitateFizica.getDataActivitate()).get(),
                inregistrareActivitateFizica.getDurataMin()));
        inregistrareActivitateFizica.setNotite(request.notite());

        return inregistrareActivitateFizicaMapper
                .toResponse(inregistrareActivitateFizicaRepository.save(inregistrareActivitateFizica));
    }

    public void stergeInregistrareActivitateFizica(Long id, UUID utilizatorId) {

        InregistrareActivitateFizica inregistrareActivitateFizica =
                inregistrareActivitateFizicaRepository
                        .findByIdAndUtilizatorIdAndSursaDate(id, utilizatorId, SursaDate.MANUAL)
                        .orElseThrow(() -> new IllegalStateException("Înregistrarea activității fizice cu id-ul "
                                + id + " nu a fost găsită."));

        inregistrareActivitateFizicaRepository.delete(inregistrareActivitateFizica);
    }

    public List<InregistrareActivitateFizicaResponse> adaugaInregistrareHealthConnect(List<HealthConnectRequest> request, UUID utilizatorId) {

        Utilizator utilizator = utilizatorRepository.findById(utilizatorId)
                .orElseThrow(() -> new IllegalStateException("Utilizatorul cu id-ul " + utilizatorId + " nu a fost găsit."));

        return request.stream().map(healthConnectRequest -> {

            InregistrareActivitateFizica inregistrareHealthConnect =
                    inregistrareActivitateFizicaRepository.findFirstByUtilizatorIdAndSursaDateAndDataActivitate(
                                    utilizatorId, SursaDate.HEALTH_CONNECT, healthConnectRequest.dataActivitate())
                            .orElse(new InregistrareActivitateFizica());

            inregistrareHealthConnect.setCaloriiArse(healthConnectRequest.caloriiArse());
            inregistrareHealthConnect.setNumarPasi(healthConnectRequest.numarPasi());
            inregistrareHealthConnect.setDataActivitate(healthConnectRequest.dataActivitate());
            inregistrareHealthConnect.setSursaDate(SursaDate.HEALTH_CONNECT);
            inregistrareHealthConnect.setNume("Health Connect");
            inregistrareHealthConnect.setUtilizator(utilizator);

            return inregistrareActivitateFizicaMapper
                    .toResponse(inregistrareActivitateFizicaRepository.save(inregistrareHealthConnect));
        }).toList();
    }
}
