import 'package:equatable/equatable.dart';

abstract class ArtistEvent extends Equatable {
  const ArtistEvent();

  @override
  List<Object> get props => [];
}

class FetchArtists extends ArtistEvent {}